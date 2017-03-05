#ifndef SONGSLISTMODEL_H
#define SONGSLISTMODEL_H

#include <QAbstractListModel>

class Song;

class SongsListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum SongRoles {
        TitleRole,
        ArtistRole,
        TempoRole,
        BeatsPerMeasureRole
    };

    explicit SongsListModel(QObject *parent = 0);

    // Reimplemented methods
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool moveRows(const QModelIndex &sourceParent, int sourceRow, int count,
                  const QModelIndex &destinationParent, int destinationChild);

    // New methods
    int count() const { return rowCount(); }
    QList<const Song*> songsList() const;
    void setSongsList(QList<const Song *>);

public slots:
    Song *get(int index) const;

signals:
    void countChanged(int count);

private:
    QList<Song*> m_songsList;
};

#endif // SONGSLISTMODEL_H
