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

public:
    explicit UserSettings(QObject *parent = 0);

    QQmlListProperty<Song> songList();

signals:

public slots:

private:
    QList<Song*> m_songs;
};

#endif // USERSETTINGS_H
