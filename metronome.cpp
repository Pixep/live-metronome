#include "metronome.h"
#include <QDebug>
#include <QAudioFormat>
#include <QAudioDeviceInfo>
#include <QAudioOutput>
#include <qmath.h>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Metronome::Metronome() :
    m_tempo(0),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0),
    m_needTempoUpdate(false)
{
    setTempo(80);
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);

    m_lowTick.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick2.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick3.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));

    // TODO link both buffer creation in one method
    m_stream.setBufferSizeInMillisec(2000);

    loadSounds();
}

void Metronome::loadSounds()
{
    generateTick(m_tickLowSoundBuffer, false);
    generateTick(m_tickHighSoundBuffer, true);
}

void Metronome::generateTick(QVector<char> &audioBuffer, bool highPitch)
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

void Metronome::setTempo(int value)
{
    if (m_tempo == value)
        return;

    m_tempo = value;

    if (m_timer.isActive())
        m_needTempoUpdate = true;

    resetTempoSpecificCounters();

    emit tempoChanged();
}

void Metronome::setBeatsPerMeasure(int value)
{
    if (m_beatsPerMeasure == value)
        return;

    m_beatsPerMeasure = value;
    emit beatsPerMeasureChanged();
}

void Metronome::start()
{
    m_stream.start();

    m_beatsElapsed = 0;
    m_lastTickElapsed.start();
    resetTempoSpecificCounters();

    m_timer.start(tempoInterval());
    notifyTick(true);

    emit playingChanged();
}

void Metronome::stop()
{
    m_timer.stop();
    qWarning() << "Stop or Not ?";

    emit playingChanged();
}

void Metronome::resetTempoSpecificCounters()
{
    m_tempoSessionElapsed.start();
    m_tempoSessionTickCount = 0;
    m_needTempoUpdate = false;
}

void Metronome::onTick()
{
    //qWarning() << "Tick ?" << m_lastTickElapsed.elapsed() << 1000 * 60 / m_bpm;
    while(m_lastTickElapsed.elapsed() < tempoInterval())
    {
        int i = 0;
        ++i;
    }

    m_lastTickElapsed.start();
    ++m_tempoSessionTickCount;
    ++m_beatsElapsed;
    notifyTick(m_beatsElapsed % m_beatsPerMeasure == 0);

    if (m_needTempoUpdate)
        resetTempoSpecificCounters();

    //qWarning() << "Tick!" << m_lastTickElapsed.elapsed() << ((1 + m_tempoSessionTickCount) * 1000 * 60 / m_bpm) << m_tempoSessionElapsed.elapsed();
    int correctedInterval = tempoInterval() * (1 + m_tempoSessionTickCount) - m_tempoSessionElapsed.elapsed() - m_lastTickElapsed.elapsed() - 20;
    if (correctedInterval <= 0)
        correctedInterval = tempoInterval();

    m_timer.start(correctedInterval);
}

void Metronome::notifyTick(bool isMeasureTick)
{
    playTick(isMeasureTick);

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
