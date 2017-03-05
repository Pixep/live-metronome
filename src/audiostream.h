#ifndef AUDIOSTREAM_H
#define AUDIOSTREAM_H

#include <QObject>
#include <QtMultimedia/QAudioOutput>

class AudioStream : public QObject
{
    Q_OBJECT
public:
    explicit AudioStream(QObject *parent = 0);

    qint64 bufferSize() const { return m_bufferSize; }
    float bufferFillingRatio() const;
    QAudioFormat format() const;

    bool isActive() { return m_audioStream != NULL; }

public slots:
    void setBufferSizeInMillisec(int ms);
    void start();
    void stop();
    bool play(char *data, qint64 byteCount);
    bool isMuted() { return m_audioOutput->volume() < 0.01; }
    void mute() { setMuted(true); }
    void setMuted(bool muted);

private slots:
    //void onOutputNotify();

private:
    QAudioOutput* m_audioOutput;
    QIODevice* m_audioStream;
    qint64 m_bufferSize;
};

#endif // AUDIOSTREAM_H
