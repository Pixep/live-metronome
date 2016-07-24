#include "audiostream.h"

#include <QDebug>

AudioStream::AudioStream(QObject *parent) : QObject(parent),
    m_audioOutput(NULL),
    m_audioStream(NULL),
    m_bufferSize(0)
{
    QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());
    QAudioFormat format = info.preferredFormat();
    format.setSampleRate(8000);
    format.setSampleSize(16);
    format.setChannelCount(1);
    format = info.nearestFormat(format);

    if (!info.isFormatSupported(format)) {
        qWarning() << "Specified raw audio format is not supported by backend, cannot play audio. Supported options:";
        qWarning() << info.supportedByteOrders();
        qWarning() << info.supportedChannelCounts();
        qWarning() << info.supportedCodecs();
        qWarning() << info.supportedSampleRates();
        qWarning() << info.supportedSampleSizes();
        qWarning() << info.supportedSampleTypes();

        format = info.preferredFormat();
    }

    m_audioOutput = new QAudioOutput(format, this);
}

QAudioFormat AudioStream::format() const
{
    return m_audioOutput->format();
}

void AudioStream::setBufferSizeInMillisec(int ms)
{
    if (isActive())
        qWarning() << Q_FUNC_INFO << "Buffer size changed while playing, ignored until next call to 'play'";

    m_bufferSize = ms * m_audioOutput->format().sampleRate() * m_audioOutput->format().sampleSize()/8 / 1000;
    qDebug() << "Audio buffer size=" << m_bufferSize << "bytes";
    m_audioOutput->setBufferSize(m_bufferSize);
}

void AudioStream::start()
{
    m_audioStream = m_audioOutput->start();
}

void AudioStream::stop()
{
    m_audioStream = NULL;
    m_audioOutput->stop();
}

bool AudioStream::play(char *data, qint64 byteCount)
{
    if ( ! isActive())
        return false;

    qWarning() << "Write expected: " << byteCount << " | Write done: " << m_audioStream->write(data, byteCount);
    return true;
}
