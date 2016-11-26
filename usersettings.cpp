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

    connect(this, &UserSettings::setlistChanged, &UserSettings::setlistIndexChanged);
    connect(this, &UserSettings::setlistsChanged, &UserSettings::setlistIndexChanged);
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

QVector<const Setlist *> UserSettings::setlistsConst() const
{
    QVector<const Setlist *> setlistsConstant;
    foreach(Setlist* setlist, m_setlists)
        setlistsConstant << setlist;

    return setlistsConstant;
}

void UserSettings::resetToDefault()
{
    removeAllPlaylists_internal();

    addSetlist_internal("Live Rock");
    addSong_internal("Highway to Hell", "AC/DC", 116, 4);
    addSong_internal("Sweet home Alabama", "Mc dewy", 120, 4);
    addSong_internal("Roger that!", "Willy Smith", 105, 4);
    addSong_internal("Make me cry", "Stevie Wonder", 130, 4);
    addSetlist_internal("Jazz");
    setCurrentSetlist_internal(1);
    addSong_internal("So What", "Miles Davis", 136, 4);
    addSong_internal("Sweet valentine", "", 90, 3);
    addSong_internal("Somewhere beyond the Sea", "Frank Sinatra", 98, 4);
    addSong_internal("Shofukan", "Snarky Puppy", 120, 5);
    addSong_internal("So What", "Miles Davis", 136, 4);
    addSong_internal("Sweet valentine", "", 90, 3);
    addSong_internal("Somewhere beyond the Sea", "Frank Sinatra", 98, 4);
    addSong_internal("Shofukan", "Snarky Puppy", 120, 5);
    setCurrentSetlist_internal(0);

    emit setlistsChanged();
    emit setlistChanged();
    emit settingsModified();
}

bool UserSettings::setJsonSettings(const QString &json)
{
    removeAllPlaylists_internal();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    QJsonArray userSetlists = jsonDoc.object().value("setlists").toArray();
    for(int setlistIndex = 0; setlistIndex < userSetlists.size(); ++setlistIndex)
    {
        QJsonObject setlistObject = userSetlists.at(setlistIndex).toObject();
        QString setlistName = setlistObject.value("name").toString();
        Setlist *setlist = addSetlist_internal(setlistName);
        if (!setlist)
            continue;

        QJsonArray userSongs = setlistObject.value("songs").toArray();
        for(int songIndex = 0; songIndex < userSongs.size(); ++songIndex)
        {
            QJsonObject songObject = userSongs.at(songIndex).toObject();
            addSong_internal(songObject.value("title").toString(), songObject.value("artist").toString(),
                             songObject.value("tempo").toInt(80), songObject.value("beatsPerMeasure").toInt(4),
                             setlist);
        }
    }

    if (setlistsCount() == 0)
        addSetlist_internal(tr("New setlist"));

    int currentSetlist = jsonDoc.object().value("currentSetlist").toInt(0);
    setCurrentSetlist_internal(currentSetlist);

    emit setlistsChanged();
    emit setlistChanged();
    emit settingsModified();

    return true;
}

QString UserSettings::jsonSettings() const
{
    QJsonDocument jsonDoc;
    QJsonObject jsonDocObject;

    QJsonArray jsonArraySetlists;
    foreach(const Setlist* setlist, setlistsConst())
    {
        QJsonObject setlistObject;
        setlistObject["name"] = setlist->name();

        QJsonArray jsonArraySongs;
        foreach(const Song* song, setlist->modelConst()->songsList())
        {
            QJsonObject songObject;
            songObject["title"] = song->title();
            songObject["artist"] = song->artist();
            songObject["tempo"] = song->tempo();
            songObject["beatsPerMeasure"] = song->beatsPerMeasure();
            jsonArraySongs.append(songObject);
        }

        setlistObject["songs"] = jsonArraySongs;
        jsonArraySetlists.append(setlistObject);
    }

    jsonDocObject["setlists"] = jsonArraySetlists;
    jsonDocObject["currentSetlist"] = setlistIndex();
    jsonDoc.setObject(jsonDocObject);

    //qWarning() << jsonDoc.toJson(QJsonDocument::Indented);

    return jsonDoc.toJson(QJsonDocument::Compact);
}

bool UserSettings::setSong(int index, const QString &title, const QString &artist, int tempo, int beatsPerMeasure)
{
    if (!setSong_internal(index, title, artist, tempo, beatsPerMeasure))
        return false;

    emit settingsModified();
    return true;
}

bool UserSettings::setSong_internal(int index, const QString &title, const QString &artist, int tempo, int beatsPerMeasure, Setlist* setlist)
{
    SongsListModel* model = nullptr;
    if (setlist)
        model = setlist->model();
    else
        model = songsModel();

    QModelIndex songModelIndex = model->index(index);
    if (!songModelIndex.isValid())
        return false;

    model->setData(songModelIndex, title, SongsListModel::TitleRole);
    model->setData(songModelIndex, artist, SongsListModel::ArtistRole);
    model->setData(songModelIndex, tempo, SongsListModel::TempoRole);
    model->setData(songModelIndex, beatsPerMeasure, SongsListModel::BeatsPerMeasureRole);
    return true;
}

Setlist* UserSettings::addSetlist_internal(QString name)
{
    if ( ! Application::allowPlaylists())
    {
        qWarning() << "Adding a playlist is not allowed with free version";
        return nullptr;
    }

    if (name.isEmpty()) {
        qWarning() << "Empty setlist name";
        name = tr("New setlist");
    }

    Setlist* setlist = new Setlist();
    setlist->setName(name);
    m_setlists.append(setlist);

    if (m_currentSetlist == nullptr)
        m_currentSetlist = setlist;

    return setlist;
}

bool UserSettings::removeAllPlaylists_internal()
{
    foreach(Setlist* setlist, m_setlists)
    {
        setlist->model()->removeRows(0, setlist->model()->rowCount());
        setlist->deleteLater();
    }
    m_setlists.clear();
    m_currentSetlist = nullptr;

    return true;
}

QQmlListProperty<Setlist> UserSettings::setlistsProperty()
{
    return QQmlListProperty<Setlist>(this, &m_setlists, &UserSettings::setlistsProperty_count, &UserSettings::setlistsProperty_at);
}

int UserSettings::setlistsProperty_count(QQmlListProperty<Setlist> *listProperty)
{
    return static_cast<QVector<Setlist* >* >(listProperty->data)->count();
}

Setlist *UserSettings::setlistsProperty_at(QQmlListProperty<Setlist> *listProperty, int index)
{
    return static_cast<QVector<Setlist* >* >(listProperty->data)->value(index);
}

bool UserSettings::addSong_internal(const QString &title, const QString &artist, int tempo, int beatsPerMeasure, Setlist* setlist)
{
    SongsListModel* model = nullptr;
    if (setlist)
        model = setlist->model();
    else
        model = songsModel();

    if (model->rowCount() >= Application::maximumSongsPerPlaylist())
        return false;

    int newSongIndex = model->rowCount();
    if ( ! model->insertRow(newSongIndex))
        return false;

    setSong_internal(newSongIndex, title, artist, tempo, beatsPerMeasure, setlist);

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

bool UserSettings::addSetlist(const QString &name)
{
    if (!addSetlist_internal(name))
        return false;

    emit setlistsChanged();
    emit settingsModified();

    setCurrentSetlist(setlistsCount()-1);

    return true;
}

bool UserSettings::removeSetlist(int index)
{
    Setlist* setlistToDelete = m_setlists.value(index);
    if (!setlistToDelete)
    {
        qWarning() << "Setlist at index " << index << " not found";
        return false;
    }

    m_setlists.removeAll(setlistToDelete);
    setlistToDelete->deleteLater();

    if (setlistsCount() == 0)
        addSetlist_internal(tr("New setlist"));

    if (m_currentSetlist == setlistToDelete)
        setCurrentSetlist(0);

    emit setlistsChanged();
    emit settingsModified();
    return true;
}

bool UserSettings::setCurrentSetlist(int index)
{
    setCurrentSetlist_internal(index);

    emit settingsModified();
    return true;
}

bool UserSettings::setSetlistName(int index, const QString &name)
{
    Setlist* newSetlist = m_setlists.value(index);
    if (newSetlist == nullptr)
        return false;

    if (name.isEmpty())
        return false;

    newSetlist->setName(name);

    emit settingsModified();
    return true;
}

bool UserSettings::setCurrentSetlist_internal(int index)
{
    Setlist* newSetlist = m_setlists.value(index);
    if (newSetlist == nullptr)
        return false;

    if (m_currentSetlist == newSetlist)
        return true;

    m_currentSetlist = newSetlist;
    emit setlistChanged();

    return true;
}

int UserSettings::setlistIndex() const
{
    for(int index = 0; index < setlistsCount(); ++index)
    {
        if (m_setlists[index] == m_currentSetlist)
            return index;
    }

    return -1;
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
