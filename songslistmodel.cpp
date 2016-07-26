#include "songslistmodel.h"
#include "song.h"

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

    /*if (value != headerData(section, orientation, role)) {
        // FIXME: Implement me!
        emit headerDataChanged(orientation, section, section);
        return true;
    }*/
    return false;
}

int SongsListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    //if (!parent.isValid())
    //    return 0;

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

bool SongsListModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);

    for(int i = 0; i < count; ++i)
        m_songsList.insert(row, new Song());

    endInsertRows();
    return true;
}

bool SongsListModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || row + count > m_songsList.count())
        return false;

    beginRemoveRows(parent, row, row + count - 1);

    for(int i = 0; i < count; ++i)
    {
        Song * song = m_songsList.takeAt(row);
        song->deleteLater();
    }

    endRemoveRows();
    return true;
}

QList<const Song *> SongsListModel::songsList() const
{
    QList<const Song*> songs;
    foreach(Song* song, m_songsList)
        songs.append(song);

    return songs;
}
