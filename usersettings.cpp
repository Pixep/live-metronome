#include "usersettings.h"
#include "application.h"
#include "setlist.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QQmlEngine>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#endif

UserSettings::UserSettings(const QString& path, QObject *parent) : QObject(parent),
    m_currentSetlist(nullptr)
{
    m_storagePath = path;
    m_currentSetlist = new Setlist();
}

SongsListModel *UserSettings::songsModel()
{
    if (m_currentSetlist)
        return m_currentSetlist->model();

    return nullptr;
}

const SongsListModel *UserSettings::songsModelConst() const
{
    if (m_currentSetlist)
        return m_currentSetlist->model();

    return nullptr;
}

void UserSettings::resetToDefault()
{
    removeAllSongs();
    addSong_internal("Highway to Hell", "AC/DC", 116, 4);
    addSong_internal("So What", "Miles Davis", 136, 4);
    addSong_internal("Sweet home Alabama", "Mc dewy", 120, 4);
    addSong_internal("Sweet valentine", "", 90, 3);
    addSong_internal("Somewhere beyond the Sea", "Frank Sinatra", 98, 4);
    addSong_internal("Roger that!", "Willy Smith", 105, 4);
    addSong_internal("Make me cry", "Stevie Wonder", 130, 4);
    addSong_internal("Shofukan", "Snarky Puppy", 120, 5);

    emit settingsModified();
}

bool UserSettings::setJsonSettings(const QString &json)
{
    songsModel()->removeRows(0, songsModel()->rowCount());

    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QJsonArray userSongs = jsonDoc.object().value("songs").toArray();
    for(int songIndex = 0; songIndex < userSongs.size(); ++songIndex) {
        QJsonObject songObject = userSongs.at(songIndex).toObject();
        addSong_internal(songObject.value("title").toString(), songObject.value("artist").toString(), songObject.value("tempo").toInt(80), songObject.value("beatsPerMeasure").toInt(4));
    }

    emit settingsModified();

    return true;
}

QString UserSettings::jsonSettings() const
{
    QJsonDocument jsonDoc;
    QJsonObject jsonDocObject;

    QJsonArray jsonArraySongs;
    foreach(const Song* song, songsModelConst()->songsList())
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
    QModelIndex songModelIndex = songsModel()->index(index);
    if (!songModelIndex.isValid())
        return false;

    songsModel()->setData(songModelIndex, title, SongsListModel::TitleRole);
    songsModel()->setData(songModelIndex, artist, SongsListModel::ArtistRole);
    songsModel()->setData(songModelIndex, tempo, SongsListModel::TempoRole);
    songsModel()->setData(songModelIndex, beatsPerMeasure, SongsListModel::BeatsPerMeasureRole);
    return true;
}

bool UserSettings::addSong_internal(const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (songsModel()->rowCount() >= Application::maximumSongsPerPlaylist())
        return false;

    int newSongIndex = songsModel()->rowCount();
    if ( ! songsModel()->insertRow(newSongIndex))
        return false;

    setSong(newSongIndex, title, artist, tempo, beatsPerMeasure);

    return true;
}

bool UserSettings::addSong(const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (!addSong_internal(title, artist, tempo, beatsPerMeasure))
        return false;

    emit songAdded();
    emit settingsModified();
    return true;
}

bool UserSettings::removeSong(int index)
{
    if (!songsModel()->removeRow(index))
        return false;

    emit songRemoved(index);
    emit settingsModified();

    return true;
}

bool UserSettings::removeAllSongs()
{
    if (!songsModel()->removeRows(0, songsModel()->rowCount()))
        return false;

    emit allSongsRemoved();
    emit settingsModified();

    return true;
}

bool UserSettings::moveSong(int index, int destinationIndex)
{
    int destinationChild = destinationIndex;
    if (destinationIndex > index)
        ++destinationChild;

    if (!m_songsMoveModel.moveRow(QModelIndex(), index, QModelIndex(), destinationChild))
        return false;

    return true;
}

bool UserSettings::commitSongMoves()
{
    songsModel()->setSongsList(m_songsMoveModel.songsList());

    emit settingsModified();
    return true;
}

bool UserSettings::discardSongMoves()
{
    m_songsMoveModel.setSongsList(songsModel()->songsList());
    return true;
}
