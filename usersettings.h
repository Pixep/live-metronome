#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include "song.h"
#include "songslistmodel.h"

#include <QObject>
#include <QQmlListProperty>

class Setlist;

class UserSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Setlist* setlist READ setlist NOTIFY setlistChanged)
    Q_PROPERTY(SongsListModel* songsModel READ songsModel NOTIFY setlistChanged)
    Q_PROPERTY(SongsListModel* songsMoveModel READ songsMoveModel CONSTANT)
    Q_PROPERTY(QQmlListProperty<Setlist> setlists READ setlistsProperty NOTIFY setlistsChanged)
    Q_PROPERTY(int setlistIndex READ setlistIndex NOTIFY setlistIndexChanged)

signals:
    void settingsModified();
    void songAdded();
    void songRemoved(int removedIndex);
    void allSongsRemoved();
    void songModified();
    void setlistChanged();
    void setlistsChanged();
    void setlistIndexChanged();

public:
    explicit UserSettings(const QString& settings, QObject *parent = 0);

    QQmlListProperty<Song> songList();
    Setlist* setlist() { return m_currentSetlist; }
    SongsListModel* songsModel();
    const SongsListModel *songsModelConst() const;
    SongsListModel* songsMoveModel() { return &m_songsMoveModel; }
    QVector<Setlist*> setlists() { return m_setlists; }
    QVector<const Setlist*> setlistsConst() const;

public slots:
    void resetToDefault();
    bool setJsonSettings(const QString& json);
    QString jsonSettings() const;

    bool setSong(int index, const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool addSong(const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool removeSong(int index);
    bool removeAllSongs();

    bool moveSong(int index, int destinationIndex);

    bool addSetlist(const QString& name);
    bool removeSetlist(int index);
    bool setCurrentSetlist(int index);
    int setlistsCount() const { return m_setlists.count(); }
    int setlistIndex() const;

    bool commitSongMoves();
    bool discardSongMoves();

private:
    bool addSong_internal(const QString& title, const QString& artist, int tempo, int beatsPerMeasure, Setlist *setlist = nullptr);
    bool setSong_internal(int index, const QString& title, const QString& artist, int tempo, int beatsPerMeasure, Setlist *setlist = nullptr);
    Setlist *addSetlist_internal(const QString& name);
    bool removeAllPlaylists_internal();
    bool setCurrentSetlist_internal(int index);

    QQmlListProperty<Setlist> setlistsProperty();
    static int setlistsProperty_count(QQmlListProperty<Setlist> *listProperty);
    static Setlist* setlistsProperty_at(QQmlListProperty<Setlist> *listProperty, int index);

private:
    Setlist* m_currentSetlist;
    QVector<Setlist*> m_setlists;

    SongsListModel m_songsMoveModel;
    QString m_storagePath;
};

#endif // USERSETTINGS_H
