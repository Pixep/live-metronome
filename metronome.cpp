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
    m_audioGenerationBuffer(NULL)
{
    setTempo(80);
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);

    m_lowTick.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick2.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick3.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));

    m_stream.setBufferSizeInMillisec(2000);
    m_audioGenerationBuffer = new char[m_stream.bufferSize()];
}

Metronome::~Metronome()
{
    delete[] m_audioGenerationBuffer;
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

    resetTempoSpecificCounters();

    if (m_timer.isActive())
        m_timer.setInterval(tempoInterval());

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

    m_timer.start();
    playTick();

    emit playingChanged();
}

void Metronome::stop()
{
    m_timer.stop();
    m_stream.stop();
    emit playingChanged();
}

void Metronome::resetTempoSpecificCounters()
{
    m_tempoSessionElapsed.start();
    m_tempoSessionTickCount = 0;
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

    notifyTick(m_beatsElapsed % m_beatsPerMeasure == 0);

    //qWarning() << "Tick!" << m_lastTickElapsed.elapsed() << ((1 + m_tempoSessionTickCount) * 1000 * 60 / m_bpm) << m_tempoSessionElapsed.elapsed();
    int correctedInterval = tempoInterval() * (1 + m_tempoSessionTickCount) - m_tempoSessionElapsed.elapsed() - m_lastTickElapsed.elapsed() - 20;
    if (correctedInterval <= 0)
        correctedInterval = tempoInterval();

    m_timer.start(correctedInterval);
    ++m_beatsElapsed;
}

void Metronome::playTick()
{
    QAudioFormat format = m_stream.format();
    qint64 samplesCount = format.sampleRate() * tempoInterval() / 1000;
    qint64 audioByteSize = samplesCount * format.sampleSize()/8;

    qWarning() << format.sampleRate() << "*" << tempoInterval() << "=" << samplesCount;
    int frequency = 440;
    float sinFrequencyFactor = (float)frequency * 2 * M_PI / format.sampleRate();
    if (format.sampleSize() == 16 && format.sampleType() == QAudioFormat::SignedInt)
    {
        qint16 value;
        /*for(int i = 0; i < samplesCount; ++i)
        {
            value = 32000 * qSin((float)1000 * i / format.sampleRate());
            memcpy(&audioData[2*i], &value, 2);
        }*/
        for(int i = 0; i < samplesCount; ++i)
        {
            float scaleFactor = qMax(0.0f, (float)(format.sampleRate()/10 - i) / (format.sampleRate()/10));
            value = 32000 * qSin(sinFrequencyFactor * i) * scaleFactor;
            memcpy(&m_audioGenerationBuffer[2*i], &value, 2);
        }
    }
    else if (format.sampleSize() == 8 && format.sampleType() == QAudioFormat::SignedInt)
    {
        qint8 value;
        for(int i = 0; i < samplesCount; ++i)
        {
            value = 127 * qSin((float)1000 * i / format.sampleRate());
            memcpy(&m_audioGenerationBuffer[i], &value, 1);
        }
    }
    m_stream.play(m_audioGenerationBuffer, audioByteSize);
}

void Metronome::notifyTick(bool isMeasureTick)
{
    playTick();
/*#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com.livemetronome.MainActivity",
                                              "playTick",
                                              "()V");
#endif

    if (isMeasureTick)
        emit measureTick();
    else
        emit beatTick();*/

    /*if (m_beatsElapsed % 3 == 0)
        m_lowTick.play();
    else if (m_beatsElapsed % 3 == 1)
        m_lowTick2.play();
    else
        m_lowTick3.play();*/
}
