#include "usersettings.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QQmlEngine>

UserSettings::UserSettings(const QString& path, QObject *parent) : QObject(parent)
{
    m_storagePath = path;
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

bool UserSettings::load()
{
    //qDebug() << m_storagePath;
    return true;
}

bool UserSettings::setJsonSettings(const QString &json)
{
    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QJsonArray userSongs = jsonDoc.object().value("songs").toArray();
    for(int songIndex = 0; songIndex < userSongs.size(); ++songIndex) {
        QJsonObject songObject = userSongs.at(songIndex).toObject();
        m_songs.append(new Song(songObject.value("artist").toString(), songObject.value("title").toString(), songObject.value("tempo").toInt(80)));
    }

    emit songListChanged();

    return true;
}
