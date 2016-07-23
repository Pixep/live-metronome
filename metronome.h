#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(int tempo READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(int beatsPerMeasure READ beatsPerMeasure WRITE setBeatsPerMeasure NOTIFY beatsPerMeasureChanged)

public:
    Metronome();

    bool playing() const { return m_timer.isActive(); }
    void setPlaying(bool play);
    int bpm() const { return m_bpm; }
    void setBpm(int value);
    int beatsPerMeasure() const { return m_beatsPerMeasure; }
    void setBeatsPerMeasure(int value);

signals:
    void playingChanged();
    void bpmChanged();
    void beatsPerMeasureChanged();

    void measureTick();
    void beatTick();

public slots:
    void start();
    void stop();
    void onTick();

private:
    int m_bpm;
    int m_beatsPerMeasure;
    int m_beatsElapsed;
    QTimer m_timer;

    int m_tempoSessionTickCount;
    QElapsedTimer m_tempoSessionElapsed;
    QElapsedTimer m_lastTickElapsed;
};

#endif // METRONOME_H
