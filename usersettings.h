#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include <QObject>
#include <QQmlListProperty>

#include "song.h"

class UserSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Song> songList READ songList NOTIFY songListChanged)

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
    QList<Song*> m_songs;
    QString m_storagePath;
    const int MaxSongs = 6;
};

#endif // USERSETTINGS_H
