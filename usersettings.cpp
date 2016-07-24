#include "usersettings.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QQmlEngine>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#endif

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

void UserSettings::resetToDefault()
{
    m_songs.clear();
    m_songs.append(new Song("AC/DC", "Highway to Hell", 116));
    m_songs.append(new Song("Miles Davis", "So What", 136));

    emit songListChanged();
    emit settingsModified();
}

bool UserSettings::setJsonSettings(const QString &json)
{
    m_songs.clear();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QJsonArray userSongs = jsonDoc.object().value("songs").toArray();
    for(int songIndex = 0; songIndex < userSongs.size(); ++songIndex) {
        QJsonObject songObject = userSongs.at(songIndex).toObject();
        addSong_internal(songObject.value("artist").toString(), songObject.value("title").toString(), songObject.value("tempo").toInt(80), songObject.value("beatsPerMeasure").toInt(4));
    }

    emit songListChanged();
    emit settingsModified();

    return true;
}

QString UserSettings::jsonSettings() const
{
    QJsonDocument jsonDoc;
    QJsonObject jsonDocObject;

    QJsonArray jsonArraySongs;
    foreach(const Song* song, m_songs)
    {
        QJsonObject songObject;
        songObject["title"] = song->title();
        songObject["artist"] = song->artist();
        songObject["tempo"] = song->tempo();
        songObject["beatsPerMeasure"] = song->beatsPerMeasure();
        jsonArraySongs.append(songObject);
    }

    jsonDocObject["songs"] = jsonArraySongs;
    jsonDoc.setObject(jsonDocObject);

    return jsonDoc.toJson(QJsonDocument::Compact);
}

bool UserSettings::setSong(int index, const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (index < 0 || index >= m_songs.size())
        return false;

    Song* song = m_songs[index];
    song->setTitle(title);
    song->setArtist(artist);
    song->setTempo(tempo);
    song->setBeatsPerMeasure(beatsPerMeasure);

    emit settingsModified();
    return true;
}

bool UserSettings::addSong_internal(const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (m_songs.count() >= MaxSongs)
        return false;

    Song* newSong = new Song(artist, title, tempo, beatsPerMeasure);
    m_songs.append(newSong);

    return true;
}

bool UserSettings::addSong(const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (!addSong_internal(title, artist, tempo, beatsPerMeasure))
        return false;

    emit songListChanged();
    emit songAdded();
    emit settingsModified();
    return true;
}

bool UserSettings::removeSong(int index)
{
    if (index < 0 || index >= m_songs.size())
        return false;

    Song* song = m_songs.takeAt(index);
    song->deleteLater();

    emit songListChanged();
    emit songRemoved(index);
    emit settingsModified();

    return true;
}

bool UserSettings::removeAllSongs()
{
    foreach (Song* song, m_songs) {
        song->deleteLater();
    }
    m_songs.clear();

    emit songListChanged();
    emit allSongsRemoved();
    emit settingsModified();

    return true;
}
