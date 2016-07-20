#include "metronome.h"

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Metronome::Metronome() :
    m_bpm(0),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0)
{
    setBpm(80);
    m_timer.setSingleShot(false);
    connect(&m_timer, &QTimer::timeout, this, &Metronome::onTick);

#ifdef Q_OS_ANDROID
    /*QAndroidJniObject value = QAndroidJniObject::callStaticObjectMethod("MainThing",
                                              "test", "()Ljava/lang/String;");*/
    QAndroidJniObject::callStaticMethod<void>("org.qtproject.example.TickPlayer",
                                              "instantiate", "()V");
#endif
}

void Metronome::setPlaying(bool play)
{
    if (play)
        start();
    else
        stop();
}

void Metronome::setBpm(int value)
{
    if (m_bpm == value)
        return;

    m_bpm = value;
    m_timer.setInterval(1000 * 60 / m_bpm);

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
    emit playingChanged();
}

void Metronome::stop()
{
    m_timer.stop();
    m_beatsElapsed = 0;
    emit playingChanged();
}

void Metronome::onTick()
{
    qWarning() << "Tick!" << m_elapsedTimer.elapsed();
    m_elapsedTimer.start();
    if (m_beatsElapsed % m_beatsPerMeasure == 0)
    {
        emit beatTick();


    }
    else
    {
        emit measureTick();
    }
#ifdef Q_OS_ANDROID
        QAndroidJniObject::callStaticMethod<void>("org.qtproject.example.TickPlayer",
                                                  "playTick", "()V");
#endif
    ++m_beatsElapsed;
}
