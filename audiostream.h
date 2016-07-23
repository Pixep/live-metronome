#ifndef AUDIOSTREAM_H
#define AUDIOSTREAM_H

#include <QObject>
#include <QtMultimedia/QAudioOutput>

class AudioStream : public QObject
{
    Q_OBJECT
public:
    explicit AudioStream(QObject *parent = 0);

    qint64 bufferSize() const;
    QAudioFormat format() const;

public slots:
    void setBufferSizeInMillisec(int ms);
    void start();
    void stop();
    bool play(char *data, qint64 byteCount);

private:
    QAudioOutput* m_audioOutput;
    QIODevice* m_audioStream;
};

#endif // AUDIOSTREAM_H
