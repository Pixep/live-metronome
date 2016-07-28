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

void UserSettings::resetToDefault()
{
    removeAllSongs();
    addSong_internal("Highway to Hell", "AC/DC", 116, 4);
    addSong_internal("So What", "Miles Davis", 136, 4);

    emit songListChanged();
    emit settingsModified();
}

bool UserSettings::setJsonSettings(const QString &json)
{
    m_songsModel.removeRows(0, m_songsModel.rowCount());

    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QJsonArray userSongs = jsonDoc.object().value("songs").toArray();
    for(int songIndex = 0; songIndex < userSongs.size(); ++songIndex) {
        QJsonObject songObject = userSongs.at(songIndex).toObject();
        addSong_internal(songObject.value("title").toString(), songObject.value("artist").toString(), songObject.value("tempo").toInt(80), songObject.value("beatsPerMeasure").toInt(4));
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
    foreach(const Song* song, m_songsModel.songsList())
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
    if (!setSong_internal(index, title, artist, tempo, beatsPerMeasure))
        return false;

    emit settingsModified();
    return true;
}

bool UserSettings::setSong_internal(int index, const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    QModelIndex songModelIndex = m_songsModel.index(index);
    if (!songModelIndex.isValid())
        return false;

    m_songsModel.setData(songModelIndex, title, SongsListModel::TitleRole);
    m_songsModel.setData(songModelIndex, artist, SongsListModel::ArtistRole);
    m_songsModel.setData(songModelIndex, tempo, SongsListModel::TempoRole);
    m_songsModel.setData(songModelIndex, beatsPerMeasure, SongsListModel::BeatsPerMeasureRole);
}

bool UserSettings::addSong_internal(const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (m_songsModel.rowCount() >= MaxSongs)
        return false;

    int newSongIndex = m_songsModel.rowCount();
    if ( ! m_songsModel.insertRow(newSongIndex))
        return false;

    setSong(newSongIndex, title, artist, tempo, beatsPerMeasure);

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
    if (!m_songsModel.removeRow(index))
        return false;

    emit songListChanged();
    emit songRemoved(index);
    emit settingsModified();

    return true;
}

bool UserSettings::removeAllSongs()
{
    if (!m_songsModel.removeRows(0, m_songsModel.rowCount()))
        return false;

    emit songListChanged();
    emit allSongsRemoved();
    emit settingsModified();

    return true;
}

bool UserSettings::moveSong(int index, int destinationIndex)
{
    int destinationChild = destinationIndex;
    if (destinationIndex > index)
        ++destinationChild;

    if (!m_songsModel.moveRow(QModelIndex(), index, QModelIndex(), destinationChild))
        return false;

    emit songListChanged();
    emit settingsModified();

    return true;
}
