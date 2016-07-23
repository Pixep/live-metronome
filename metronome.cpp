#include "metronome.h"
#include <QDebug>
#include <QAudioFormat>
#include <QAudioDeviceInfo>
#include <QAudioOutput>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Metronome::Metronome() :
    m_tempo(0),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0)
{
    setTempo(80);
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);

    m_lowTick.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick2.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
    m_lowTick3.setSource(QUrl("qrc:/sounds/click_analog_low5.wav"));
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
    m_beatsElapsed = 0;
    m_lastTickElapsed.start();
    resetTempoSpecificCounters();

    m_timer.start();

    QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());
    QAudioFormat format = info.preferredFormat();

    QByteArray * bufferArray = new QByteArray( 2 * format.sampleRate() * format.sampleSize()/8, 0);
    m_audioBuffer.setBuffer(bufferArray);
    m_audioBuffer.open(QIODevice::ReadWrite);

    /*int intValue;
    unsigned int uintValue;
    char charValue;
    unsigned char ucharValue;*/

    if (format.sampleSize() == 16 && format.sampleType() == QAudioFormat::SignedInt)
    {
        qint16 value;
        for(int i = 0; i < format.sampleRate() * 2; ++i)
        {
            value = 32000 * qSin((float)1000 * i / format.sampleRate());
            m_audioBuffer.write(reinterpret_cast<char*>(&value), 2);

            if (i < 20)
                qWarning() << value;
        }
    }

    m_audioBuffer.seek(0);

        // Set up the format, eg.
        /*format.setSampleRate(44100);
        format.setChannelCount(1);
        format.setSampleSize(16);
        format.setCodec("audio/pcm");
        format.setByteOrder(QAudioFormat::LittleEndian);
        format.setSampleType(QAudioFormat::UnSignedInt);*/

    if (true || !info.isFormatSupported(format)) {
        //qWarning() << "Raw audio format not supported by backend, cannot play audio.";
        qWarning() << info.supportedByteOrders();
        qWarning() << info.supportedChannelCounts();
        qWarning() << info.supportedCodecs();
        qWarning() << info.supportedSampleRates();
        qWarning() << info.supportedSampleSizes();
        qWarning() << info.supportedSampleTypes();
        //return;
    }

    QAudioOutput * audio = new QAudioOutput(format, this);
    //connect(audio, SIGNAL(stateChanged(QAudio::State)), this, SLOT(handleStateChanged(QAudio::State)));
    audio->start(&m_audioBuffer);

    emit playingChanged();
}

void Metronome::stop()
{
    m_timer.stop();
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

void Metronome::notifyTick(bool isMeasureTick)
{
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
