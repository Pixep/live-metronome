#include "metronome.h"
#include "platform.h"

#include <QDebug>
#include <QAudioFormat>
#include <QAudioDeviceInfo>
#include <QAudioOutput>
#include <qmath.h>

Metronome::Metronome() :
    m_tempo(80),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0),
    m_needTempoUpdate(false)
{
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);

    m_lowTick.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick2.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick3.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));

    m_stream.setBufferSizeInMillisec(4000);
    //connect(&m_stream, &AudioStream::tickPlayed, this, &Metronome::onTickPlayed);

    loadSounds();
}

void Metronome::loadSounds()
{
    generateTickAudio(m_tickLowSoundBuffer, false);
    generateTickAudio(m_tickHighSoundBuffer, true);
}

void Metronome::generateTickAudio(QVector<char> &audioBuffer, bool highPitch)
{
    audioBuffer.resize(m_stream.bufferSize());

    // 1/10s max audio "content"
    QAudioFormat format = m_stream.format();
    qint64 samplesCount = 0.1 * format.sampleRate();

    int frequency = highPitch ? 659 : 440;
    float sinFrequencyFactor = (float)frequency * 2 * M_PI / format.sampleRate();

    if (format.sampleSize() == 16 && format.sampleType() == QAudioFormat::SignedInt)
    {
        qint16 value;
        for(int i = 0; i < samplesCount; ++i)
        {
            float scaleFactor = qMax(0.0f, (float)(format.sampleRate()/10 - i) / (format.sampleRate()/10));
            value = 32000 * qSin(sinFrequencyFactor * i) * scaleFactor;
            memcpy(&audioBuffer[2*i], &value, 2);

            if (scaleFactor == 0)
                break;
        }
    }
    else if (format.sampleSize() == 8 && format.sampleType() == QAudioFormat::SignedInt)
    {
        qint8 value;
        for(int i = 0; i < samplesCount; ++i)
        {
            value = 127 * qSin((float)1000 * i / format.sampleRate());
            memcpy(&audioBuffer[i], &value, 1);
        }
    }
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
    m_timer.start(tempoInterval() - timerIntervalReduction());
    generateTicks();

    m_stream.setMuted(false);
    Platform::get()->setKeepScreenOn(true);

    emit beatIndexChanged();
    emit playingChanged(isPlaying());
}

void Metronome::stop()
{
    if (!isPlaying())
        return;

    m_timer.stop();
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

void Metronome::generateTicks()
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

        playTick(isFirstBeat());
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

        generateTicks();
    }

    int correctedInterval = tempoInterval() * (m_tempoSessionBeatsCount+1) - tempoSessionElapsed() - m_lastTickElapsed.elapsed() - timerIntervalReduction();

    if (correctedInterval <= 0) {
        qWarning() << "Incorrect timer interval, setting to 0";
        correctedInterval = 0;
    }

    m_timer.start(correctedInterval);
}

void Metronome::onTickPlayed()
{
    notifyTick(false);
}

void Metronome::notifyTick(bool isMeasureTick)
{
    if (isMeasureTick)
        emit measureTick();
    else
        emit beatTick();
}

void Metronome::playTick(bool isMeasureTick)
{
    QAudioFormat format = m_stream.format();
    qint64 samplesCount = tempoInterval() * format.sampleRate() / 1000;
    qint64 byteSize = samplesCount * format.channelCount() * format.sampleSize()/8;

    if (isMeasureTick)
        m_stream.play(m_tickHighSoundBuffer.data(), byteSize);
    else
        m_stream.play(m_tickLowSoundBuffer.data(), byteSize);
}
