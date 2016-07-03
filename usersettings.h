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
    explicit UserSettings(const QString& settings, QObject *parent = 0);

    QQmlListProperty<Song> songList();

public slots:
    void resetToDefault();
    bool setJsonSettings(const QString& json);
    QString jsonSettings() const;

private:
    QList<Song*> m_songs;
    QString m_storagePath;
};

#endif // USERSETTINGS_H
