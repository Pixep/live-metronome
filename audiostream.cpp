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

float AudioStream::bufferFillingRatio() const
{
    int currentBuffer = m_audioOutput->bufferSize();
    if (currentBuffer == 0)
        return 0;

    return ((float)currentBuffer - m_audioOutput->bytesFree()) / currentBuffer;
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
}

void AudioStream::start()
{
    if (isActive())
        return;

    m_audioOutput->setBufferSize(m_bufferSize);
    m_audioStream = m_audioOutput->start();
}

void AudioStream::stop()
{
    if (!isActive())
        return;

    m_audioStream = NULL;
    m_audioOutput->stop();
}

bool AudioStream::play(char *data, qint64 byteCount)
{
    if ( ! isActive())
        return false;

    qint64 bytesWritten = m_audioStream->write(data, byteCount);
    if (bytesWritten < byteCount)
        qWarning() << "Error writting !" << bytesWritten << "instead of:" << byteCount << "free:" << m_audioOutput->bytesFree();

    return true;
}

void AudioStream::setMuted(bool muted)
{
    if (muted)
        m_audioOutput->setVolume(0.0);
    else
        m_audioOutput->setVolume(1.0);
}
