#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QtMultimedia/QSoundEffect>

#include <QVector>
#include "audiostream.h"

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
    int tempoInterval() const { return 1000 * 60 / m_tempo; }
    int beatsPerMeasure() const { return m_beatsPerMeasure; }

    int beatIndex() const { return m_beatsElapsed % m_beatsPerMeasure; }
    int beatTotalCount() const { return m_beatsElapsed; }

    static int minTempo() { return 20; }
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

private:
    void loadSounds();
    void generateTick(QVector<char>& audioBuffer, bool highPitch);
    void resetTempoSpecificCounters();
    void notifyTick(bool isMeasureTick);
    void playTick(bool isMeasureTick);

private:
    int m_tempo;
    int m_beatsPerMeasure;
    int m_beatsElapsed;
    bool m_needTempoUpdate;
    QTimer m_timer;
    QSoundEffect m_lowTick;
    QSoundEffect m_lowTick2;
    QSoundEffect m_lowTick3;

    AudioStream m_stream;
    QVector<char> m_emptySoundBuffer;
    QVector<char> m_tickLowSoundBuffer;
    QVector<char> m_tickHighSoundBuffer;

    int m_tempoSessionTickCount;
    QElapsedTimer m_tempoSessionElapsed;
    QElapsedTimer m_lastTickElapsed;
};

#endif // METRONOME_H
