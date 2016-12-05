#include "songslistmodel.h"
#include "song.h"
#include "platform.h"

#include <QDebug>
#include <QQmlEngine>

SongsListModel::SongsListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

QVariant SongsListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    Q_UNUSED(section);
    Q_UNUSED(orientation);
    Q_UNUSED(role);

    return QVariant();
}

bool SongsListModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    Q_UNUSED(section);
    Q_UNUSED(orientation);
    Q_UNUSED(value);
    Q_UNUSED(role);

    return false;
}

int SongsListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_songsList.count();
}

QHash<int, QByteArray> SongsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[ArtistRole] = "artist";
    roles[TempoRole] = "tempo";
    roles[BeatsPerMeasureRole] = "beatsPerMeasure";

    return roles;
}

QVariant SongsListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    Song* song = m_songsList.value(index.row());
    if ( ! song)
    {
        qWarning("Fail");
        return QVariant();
    }

    switch(role)
    {
    case TitleRole: return song->title();
    case ArtistRole: return song->artist();
    case TempoRole: return song->tempo();
    case BeatsPerMeasureRole: return song->beatsPerMeasure();
    }

    return QVariant();
}

bool SongsListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) == value)
        return false;

    Song* song = m_songsList.value(index.row());
    if (!song)
        return false;

    switch(role)
    {
    case TitleRole: song->setTitle(value.toString());
        break;
    case ArtistRole: song->setArtist(value.toString());
        break;
    case TempoRole: song->setTempo(value.toInt());
        break;
    case BeatsPerMeasureRole: song->setBeatsPerMeasure(value.toInt());
        break;
    default:
        return false;
    }

    emit dataChanged(index, index, QVector<int>() << role);
    return true;
}

Qt::ItemFlags SongsListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
}

bool SongsListModel::insertRows(int row, int insertCount, const QModelIndex &parent)
{
    if (insertCount <= 0)
        return true;

    beginInsertRows(parent, row, row + insertCount - 1);

    for(int i = 0; i < insertCount; ++i)
        m_songsList.insert(row, new Song());

    endInsertRows();
    countChanged(count());

    return true;
}

bool SongsListModel::removeRows(int row, int removeCount, const QModelIndex &parent)
{
    if (removeCount <= 0)
        return true;

    if (row < 0 || row + removeCount > count())
        return false;

    beginRemoveRows(parent, row, row + removeCount - 1);

    for(int i = 0; i < removeCount; ++i)
    {
        Song * song = m_songsList.takeAt(row);
        song->deleteLater();
    }

    endRemoveRows();
    countChanged(count());

    return true;
}

bool SongsListModel::moveRows(const QModelIndex &sourceParent, int sourceRow, int count, const QModelIndex &destinationParent, int destinationChild)
{
    if (sourceRow == destinationChild)
        return false;

    if (count <= 0)
        return true;

    // Not supported
    if (count > 1)
        return false;

    if (!beginMoveRows(sourceParent, sourceRow, sourceRow+count-1, destinationParent, destinationChild))
        return false;

    if (destinationChild > sourceRow)
        m_songsList.move(sourceRow, destinationChild-1);
    else
        m_songsList.move(sourceRow, destinationChild);

    endMoveRows();

    return true;
}

QList<const Song *> SongsListModel::songsList() const
{
    QList<const Song*> songs;
    foreach(Song* song, m_songsList)
        songs.append(song);

    return songs;
}

void SongsListModel::setSongsList(QList<const Song *> songs)
{
    beginResetModel();

    // Clear all
    int songsCount = m_songsList.count();
    for(int i = 0; i < songsCount; ++i)
    {
        Song * song = m_songsList.takeAt(0);
        song->deleteLater();
    }

    // Set all
    foreach(const Song* song, songs)
    {
        Song * newSong = new Song(*song);
        m_songsList.append(newSong);
    }

    endResetModel();
}

Song *SongsListModel::get(int indexValue) const
{
    Song *song = m_songsList.value(indexValue);
    if (song != nullptr)
        QQmlEngine::setObjectOwnership(song, QQmlEngine::CppOwnership);

    return song;
}
