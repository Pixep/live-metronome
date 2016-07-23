#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QtMultimedia/QSoundEffect>

#include <QDataStream>
#include <QBuffer>
#include "audiostream.h"

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(int tempo READ tempo WRITE setTempo NOTIFY tempoChanged)
    Q_PROPERTY(int beatsPerMeasure READ beatsPerMeasure WRITE setBeatsPerMeasure NOTIFY beatsPerMeasureChanged)

public:
    Metronome();
    ~Metronome();

    bool playing() const { return m_timer.isActive(); }
    int tempo() const { return m_tempo; }
    int tempoInterval() const { return 1000 * 60 / m_tempo; }
    int beatsPerMeasure() const { return m_beatsPerMeasure; }

    void setPlaying(bool play);
    void setTempo(int value);
    void setBeatsPerMeasure(int value);

signals:
    void playingChanged();
    void tempoChanged();
    void beatsPerMeasureChanged();

    void measureTick();
    void beatTick();

public slots:
    void start();
    void stop();
    void onTick();

private:
    void resetTempoSpecificCounters();
    void notifyTick(bool isMeasureTick);
    void playTick();

private:
    int m_tempo;
    int m_beatsPerMeasure;
    int m_beatsElapsed;
    QTimer m_timer;
    QSoundEffect m_lowTick;
    QSoundEffect m_lowTick2;
    QSoundEffect m_lowTick3;

    AudioStream m_stream;
    char* m_audioGenerationBuffer;

    int m_tempoSessionTickCount;
    QElapsedTimer m_tempoSessionElapsed;
    QElapsedTimer m_lastTickElapsed;
};

#endif // METRONOME_H
