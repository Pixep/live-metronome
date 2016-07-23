#include "metronome.h"
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Metronome::Metronome() :
    m_bpm(0),
    m_beatsPerMeasure(4),
    m_beatsElapsed(0)
{
    setBpm(80);
    //m_timer.setSingleShot(false);
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
    m_tempoSessionTickCount = 0;
    m_tempoSessionElapsed.start();

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
    m_tempoSessionElapsed.start();
    m_lastTickElapsed.start();
    m_tempoSessionTickCount = 0;
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
    //qWarning() << "Tick ?" << m_lastTickElapsed.elapsed() << 1000 * 60 / m_bpm;
    while(m_lastTickElapsed.elapsed() < 1000 * 60 / m_bpm)
    {
        int i = 0;
        ++i;
    }

    m_lastTickElapsed.start();
    ++m_tempoSessionTickCount;

#ifdef Q_OS_ANDROID
        QAndroidJniObject::callStaticMethod<void>("org.qtproject.example.TickPlayer",
                                                  "playTick", "()V");
#endif
    /*if (m_beatsElapsed % m_beatsPerMeasure == 0)
    {
        emit measureTick();
    }
    else
    {
        emit beatTick();
    }*/

    //qWarning() << "Tick!" << m_lastTickElapsed.elapsed() << ((1 + m_tempoSessionTickCount) * 1000 * 60 / m_bpm) << m_tempoSessionElapsed.elapsed();
    m_timer.start(((1 + m_tempoSessionTickCount) * 1000 * 60 / m_bpm) - m_tempoSessionElapsed.elapsed() - 20);

    ++m_beatsElapsed;
}
