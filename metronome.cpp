#include "metronome.h"

Metronome::Metronome() :
    m_bpm(80),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0)
{
    m_timer.setInterval(m_bpm);
    m_timer.setSingleShot(false);
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);
}

void Metronome::setBpm(int value)
{
    if (m_bpm == value)
        return;

    m_bpm = value;
    m_timer.setInterval(m_bpm);

    emit bpmChanged();
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
    m_timer.start();
}

void Metronome::stop()
{
    m_timer.stop();
    m_beatsElapsed = 0;
}

void Metronome::onTick()
{
    if (m_beatsElapsed % m_beatsPerMeasure == 0)
        emit beatTick();
    else
        emit measureTick();

    ++m_beatsElapsed;
}
