#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include "song.h"
#include "songslistmodel.h"

#include <QObject>
#include <QQmlListProperty>

class UserSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SongsListModel* songsModel READ songsModel CONSTANT)

signals:
    void songListChanged();
    void settingsModified();
    void songAdded();
    void songRemoved(int removedIndex);
    void allSongsRemoved();
    void songModified();

public:
    explicit UserSettings(const QString& settings, QObject *parent = 0);

    QQmlListProperty<Song> songList();
    SongsListModel* songsModel() { return &m_songsModel; }

public slots:
    void resetToDefault();
    bool setJsonSettings(const QString& json);
    QString jsonSettings() const;

    bool setSong(int index, const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool addSong(const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool removeSong(int index);
    bool removeAllSongs();

private:
    bool addSong_internal(const QString& title, const QString& artist, int tempo, int beatsPerMeasure);

private:
    SongsListModel m_songsModel;

    QString m_storagePath;
    const int MaxSongs = 6;
};

#endif // USERSETTINGS_H
