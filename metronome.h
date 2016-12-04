#ifndef METRONOME_H
#define METRONOME_H

#include "audiostream.h"

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QAudioDecoder>
#include <QVector>

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ isPlaying WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(int tempo READ tempo WRITE setTempo NOTIFY tempoChanged)
    Q_PROPERTY(int beatsPerMeasure READ beatsPerMeasure WRITE setBeatsPerMeasure NOTIFY beatsPerMeasureChanged)

    Q_PROPERTY(int beatIndex READ beatIndex NOTIFY beatIndexChanged)
    Q_PROPERTY(int beatTotalCount READ beatTotalCount NOTIFY beatIndexChanged)

    Q_PROPERTY(int minTempo READ minTempo CONSTANT)
    Q_PROPERTY(int maxTempo READ maxTempo CONSTANT)
    Q_PROPERTY(int minBeatsPerMeasure READ minBeatsPerMeasure CONSTANT)
    Q_PROPERTY(int maxBeatsPerMeasure READ maxBeatsPerMeasure CONSTANT)

public:
    Metronome();

    bool isPlaying() const { return m_timer.isActive(); }
    int tempo() const { return m_tempo; }
    int beatsPerMeasure() const { return m_beatsPerMeasure; }

    int beatIndex() const { return m_beatsElapsed % m_beatsPerMeasure; }
    int beatTotalCount() const { return m_beatsElapsed; }
    bool isFirstBeat() const { return beatIndex() == 0; }

    static int minTempo() { return 30; }
    static int maxTempo() { return 400; }
    static int minBeatsPerMeasure() { return 1; }
    static int maxBeatsPerMeasure() { return 64; }

    void setPlaying(bool play);
    void setTempo(int value);
    void setBeatsPerMeasure(int newBeats);

signals:
    void playingChanged(bool isPlaying);
    void tempoChanged();
    void beatsPerMeasureChanged();
    void beatIndexChanged();

    void measureTick();
    void beatTick();

public slots:
    void start();
    void stop();
    void onTick();
    void setTickSounds(const QString& highTickFile, const QString& lowTickFile);

private slots:
    void onSoundDecodingError(QAudioDecoder::Error error);
    void onTickPlayed();

private:
    bool generateTickAudio(QVector<char>& audioBuffer, const QString &soundFile);
    template<typename T>
    bool generateTick(QVector<char> &audioBuffer, bool pSigned, int sampleRate, const QString &soundFile);

    void notifyTick(bool isMeasureTick);
    void resetTempoSpecificCounters();
    void prepareTicks();
    void playSound(int duration, char* soundData, qint64 soundSize);
    qint64 tempoSessionElapsed() const { return m_tempoSessionElapsed.elapsed() + m_tempoSessionVirtualElapsed; }
    int timerIntervalReduction() const { return 50; }
    int tempoInterval() const { return 1000 * 60 / m_actualTempo; }

private:    
    int m_tempo;
    int m_actualTempo;
    int m_beatsPerMeasure;
    int m_beatsElapsed;
    bool m_needTempoUpdate;
    QTimer m_timer;

    AudioStream m_stream;
    QAudioDecoder m_audioDecoder;
    QVector<char> m_tickLowSoundBuffer;
    QVector<char> m_tickHighSoundBuffer;
    QVector<char> m_tickLowSoundBufferPreview;
    QVector<char> m_tickHighSoundBufferPreview;
    QAudioBuffer m_tickLowBuffer;
    QAudioBuffer m_tickHighBuffer;

    int m_tempoSessionBeatsCount;
    QElapsedTimer m_tempoSessionElapsed;
    qint64 m_tempoSessionVirtualElapsed;
    QElapsedTimer m_lastTickElapsed;
};

#endif // METRONOME_H
