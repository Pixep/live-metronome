#ifndef METRONOME_H
#define METRONOME_H

#include <QObject>
#include <QTimer>

class Metronome : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int bpm READ bpm WRITE setBpm NOTIFY bpmChanged)
    Q_PROPERTY(int beatsPerMeasure READ beatsPerMeasure WRITE setBeatsPerMeasure NOTIFY beatsPerMeasureChanged)

public:
    Metronome();

    int bpm() const { return m_bpm; }
    void setBpm(int value);
    int beatsPerMeasure() const { return m_beatsPerMeasure; }
    void setBeatsPerMeasure(int value);

signals:
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
};

#endif // METRONOME_H
