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

public:
    explicit UserSettings(const QString& settings, QObject *parent = 0);

    QQmlListProperty<Song> songList();

public slots:
    void resetToDefault();
    bool setJsonSettings(const QString& json);
    QString jsonSettings() const;

    bool setSong(int index, const QString& title, const QString& artist, int tempo);
    bool addSong(const QString& title, const QString& artist, int tempo);
    bool removeSong(int index);
    bool removeAllSongs();

private:
    QList<Song*> m_songs;
    QString m_storagePath;
};

#endif // USERSETTINGS_H
