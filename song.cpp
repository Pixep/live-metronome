#include "song.h"
#include "metronome.h"

#include <QtMath>

Song::Song(QObject *parent) : QObject(parent),
    m_tempo(110),
    m_beatsPerMeasure(4)
{
}

Song::Song(const Song &other) : QObject(other.parent())
{
    setArtist(other.artist());
    setTitle(other.title());
    setTempo(other.tempo());
    setBeatsPerMeasure(other.beatsPerMeasure());
}

Song::Song(const QString &artist, const QString &title, int tempo, int beatsPerMeasure, QObject *parent) :
    QObject(parent),
    m_tempo(0),
    m_beatsPerMeasure(0)
{
    setArtist(artist);
    setTitle(title);
    setTempo(tempo);
    setBeatsPerMeasure(beatsPerMeasure);
}

void Song::setArtist(const QString& artist)
{
    if (m_artist == artist)
        return;

    m_artist = artist.left(64);
    emit artistChanged(m_artist);
}

void Song::setTitle(const QString& title)
{
    if (m_title == title)
        return;

    m_title = title.left(64);
    emit titleChanged(m_title);
}

void Song::setTempo(int tempo)
{
    tempo = qMax(qMin(tempo, Metronome::maxTempo()), Metronome::minTempo());
    if (m_tempo == tempo)
        return;

    m_tempo = tempo;
    emit tempoChanged(m_tempo);
}

void Song::setBeatsPerMeasure(int beats)
{
    beats = qMax(qMin(beats, Metronome::maxBeatsPerMeasure()), Metronome::minBeatsPerMeasure());
    if (m_beatsPerMeasure == beats)
        return;

    m_beatsPerMeasure = beats;
    emit beatsPerMeasureChanged(m_beatsPerMeasure);
}
