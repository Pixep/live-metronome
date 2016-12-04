#include "metronome.h"
#include "platform.h"

#include <QDebug>
#include <QAudioFormat>
#include <QFile>
#include <qmath.h>
#include <QGuiApplication>

Metronome::Metronome() :
    m_suspendedPlaying(false),
    m_tempo(80),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0),
    m_needTempoUpdate(false)
{
    connect(&m_tickTimer, &QTimer::timeout, this, &Metronome::onTick);
    connect(qApp, &QGuiApplication::applicationStateChanged, this, &Metronome::onApplicationStateChanged);

    m_stream.setBufferSizeInMillisec(4000);
}

void Metronome::setTickSounds(const QString &highTickFile, const QString &lowTickFile)
{
    bool success = generateTickAudio(m_tickLowSoundBuffer, lowTickFile);
    success &=     generateTickAudio(m_tickHighSoundBuffer, highTickFile);

    if (!success)
        qWarning() << "Failed to generate audio !";
}

void Metronome::onSoundDecodingError(QAudioDecoder::Error error)
{
    qWarning() << "Failed to decode audio file with error" << error;
}

bool Metronome::generateTickAudio(QVector<char> &audioBuffer, const QString &soundFile)
{
    audioBuffer.resize(m_stream.bufferSize());

    QAudioFormat format = m_stream.format();
    if (format.sampleType() == QAudioFormat::Float)
    {
        qWarning() << "Float audio format not supported!";
        return false;
    }

    bool signedFormat = format.sampleType() == QAudioFormat::SignedInt;
    if (format.sampleSize() == 16)
    {
        if (signedFormat)
            return generateTick<qint16>(audioBuffer, signedFormat, format.sampleRate(), soundFile);
        else
            return generateTick<quint16>(audioBuffer, signedFormat, format.sampleRate(), soundFile);
    }
    else if (format.sampleSize() == 8)
    {
        if (signedFormat)
            return generateTick<qint8>(audioBuffer, signedFormat, format.sampleRate(), soundFile);
        else
            return generateTick<quint8>(audioBuffer, signedFormat, format.sampleRate(), soundFile);
    }

    return true;
}

template<typename T>
bool Metronome::generateTick(QVector<char> &audioBuffer, bool pSigned, int sampleRate, const QString& soundFile)
{
    Q_UNUSED(sampleRate)

    std::size_t byteCount = sizeof(T);
    int range = qPow(2, 8*byteCount);
    int halfRange = range/2 - 1;
    int offset = pSigned ? 0 : halfRange;

    QFile audioFile(soundFile);
    if (!audioFile.open(QFile::ReadOnly))
    {
        qWarning() << "Failed to open sound file" << soundFile;
        return false;
    }

    // Read and remove WAV header
    QByteArray audioFileWav = audioFile.readAll();
    audioFileWav = audioFileWav.remove(0, 44);

    int silenceByteCount = audioBuffer.size() - audioFileWav.size();
    memcpy(audioBuffer.data(), audioFileWav.data(), qMin(audioBuffer.size(), audioFileWav.size()));

    if (silenceByteCount > 0)
    {
        memset(audioBuffer.data() + audioFileWav.size(), offset, silenceByteCount);
    }

    return true;
}

void Metronome::setPlaying(bool play)
{
    if (play)
        start();
    else
        stop();
}

void Metronome::setTempo(int newTempo)
{
    // Don't change value in case editing in GUI
    if (newTempo < minTempo())
        return;

    if (newTempo > maxTempo())
        newTempo = maxTempo();

    if (m_tempo == newTempo)
        return;

    m_tempo = newTempo;
    if (isPlaying())
        m_needTempoUpdate = true;

    emit tempoChanged();
}

void Metronome::setBeatsPerMeasure(int newBeats)
{
    if (newBeats < minBeatsPerMeasure())
        newBeats = minBeatsPerMeasure();
    else if (newBeats > maxBeatsPerMeasure())
        newBeats = maxBeatsPerMeasure();

    if (m_beatsPerMeasure == newBeats)
        return;

    m_beatsPerMeasure = newBeats;
    emit beatsPerMeasureChanged();
}

void Metronome::start()
{
    if (isPlaying())
        return;

    m_stream.start();

    m_beatsElapsed = -1;
    m_lastTickElapsed.start();

    resetTempoSpecificCounters();
    m_tickTimer.start(tempoInterval() - timerIntervalReduction());
    prepareTicks();

    m_stream.setMuted(false);
    Platform::get()->setKeepScreenOn(true);

    emit beatIndexChanged();
    emit playingChanged(isPlaying());
}

void Metronome::stop()
{
    if (!isPlaying())
        return;

    m_tickTimer.stop();
    m_stream.mute();
    Platform::get()->setKeepScreenOn(false);

    emit playingChanged(isPlaying());
}

void Metronome::resetTempoSpecificCounters()
{
    m_tempoSessionElapsed.start();
    m_tempoSessionBeatsCount = -1;
    m_tempoSessionVirtualElapsed = 0;
    m_needTempoUpdate = false;
    m_actualTempo = m_tempo;
}

void Metronome::prepareTicks()
{
    int bufferedCount = 0;
    while (bufferedCount == 0 || (bufferedCount < 1/*tempo()/60*/ && m_stream.bufferFillingRatio() < 0.7))
    {
        ++m_beatsElapsed;
        //qWarning() << m_beatsElapsed;
        ++m_tempoSessionBeatsCount;

        // Pre-buffered audio adds "virtual elapsed" time
        if (bufferedCount >= 1)
            m_tempoSessionVirtualElapsed += tempoInterval();

        if (isFirstBeat())
            playSound(tempoInterval(), m_tickHighSoundBuffer.data(), m_tickHighSoundBuffer.size());
        else
            playSound(tempoInterval(), m_tickLowSoundBuffer.data(), m_tickLowSoundBuffer.size());

        //qWarning() << "  #" << bufferedCount << ": " << (m_stream.bufferFillingRatio()*100);

        ++bufferedCount;
    }

    //notifyTick(isFirstBeat());
    emit beatIndexChanged();
}

void Metronome::onTick()
{
    if (m_stream.bufferFillingRatio() == 1)
    {
        // Skip and wait for next timer tick
        m_tempoSessionVirtualElapsed -= tempoInterval();
    }
    else
    {
        m_stream.setMuted(false);
        /*while(m_lastTickElapsed.elapsed() < tempoInterval())
        {
            int i = 0;
            ++i;
        }*/

        // Skip some beat if we were too slow
        int beatsElapsed = qCeil((float)tempoSessionElapsed() / tempoInterval());
        int expectedBeatsElapsed = m_tempoSessionBeatsCount+1;

        //qWarning() << "Elapsed:" << beatsElapsed << " for " << tempoSessionElapsed() << " Expected:" << tempoInterval() << " beatsElapsed:" << m_tempoSessionBeatsCount;
        if (beatsElapsed > expectedBeatsElapsed)
        {
            int skippedBeats = beatsElapsed - expectedBeatsElapsed;
            qWarning() << "Missed" << skippedBeats << "timer beats ! (last tick" << m_lastTickElapsed.elapsed() << " ago)";

            //if (skippedBeats > 1 || m_stream.bufferFillingRatio() == 0)
            {
                qWarning() << "Missed audio beats, skipping them";
                m_beatsElapsed += skippedBeats;
                m_tempoSessionBeatsCount += beatsElapsed;
            }
        }

        m_lastTickElapsed.start();

        if (m_needTempoUpdate)
            resetTempoSpecificCounters();

        prepareTicks();
    }

    int correctedInterval = tempoInterval() * (m_tempoSessionBeatsCount+1) - tempoSessionElapsed() - m_lastTickElapsed.elapsed() - timerIntervalReduction();

    if (correctedInterval <= 0) {
        qWarning() << "Incorrect timer interval, setting to 0";
        correctedInterval = 0;
    }

    m_tickTimer.start(correctedInterval);
}

void Metronome::onTickPlayed()
{
    notifyTick(false);
}

void Metronome::onApplicationStateChanged(Qt::ApplicationState state)
{
    if (state == Qt::ApplicationSuspended)
    {
        if (isPlaying())
        {
            m_suspendedPlaying = true;
            stop();
        }
    }
    else if (m_suspendedPlaying)
    {
        m_suspendedPlaying = false;
        start();
    }
}

void Metronome::notifyTick(bool isMeasureTick)
{
    if (isMeasureTick)
        emit measureTick();
    else
        emit beatTick();
}

void Metronome::playSound(int duration, char* soundData, qint64 soundSize)
{
    QAudioFormat format = m_stream.format();
    qint64 samplesCount = duration * format.sampleRate() / 1000;
    qint64 byteSize = samplesCount * format.channelCount() * format.sampleSize()/8;

    if (byteSize > soundSize)
    {
        qWarning() << "Audio buffer size insufficient";
        return;
    }

    m_stream.play(soundData, byteSize);
}
