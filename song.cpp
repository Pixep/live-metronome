#include "song.h"

#include <QtMath>

Song::Song(QObject *parent) : QObject(parent)
{
}

Song::Song(const QString &artist, const QString &title, int tempo, QObject *parent) :
    QObject(parent),
    m_artist(artist),
    m_title(title),
    m_tempo(tempo)
{
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
    if (m_tempo == tempo)
        return;

    m_tempo = qMax(qMin(tempo, 400), 10);
    emit tempoChanged(m_tempo);
}
