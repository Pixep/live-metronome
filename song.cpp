#include "song.h"

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
