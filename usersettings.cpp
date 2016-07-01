#include "usersettings.h"

UserSettings::UserSettings(QObject *parent) : QObject(parent)
{
    m_songs.append(new Song("Tower Of Power", "What is hip", 124));
    m_songs.append(new Song("Tower Of Power", "Soul with a capital Suuup", 118));
}

Song * songList_at(QQmlListProperty<Song> *property, int index) {
    return (*static_cast<QList<Song*>* >(property->data))[index];
}

void songList_append(QQmlListProperty<Song> *property, Song * value) {
    static_cast<QList<Song*>* >(property->data)->append(value);
}

void songList_clear(QQmlListProperty<Song> *property) {
    static_cast<QList<Song*>* >(property->data)->clear();
}

int songList_count(QQmlListProperty<Song> *property) {
    return static_cast<QList<Song*>* >(property->data)->length();
}

QQmlListProperty<Song> UserSettings::songList()
{
    return QQmlListProperty<Song>(this, &m_songs, &songList_append, &songList_count, &songList_at, &songList_clear);
}
