#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString artist MEMBER m_artist NOTIFY artistChanged)
    Q_PROPERTY(QString title MEMBER m_title NOTIFY titleChanged)
    Q_PROPERTY(int tempo MEMBER m_tempo NOTIFY tempoChanged)

public:
    explicit Song(QObject *parent = 0);
    explicit Song(const QString &artist, const QString &title, int tempo, QObject *parent = 0);

signals:
    void artistChanged(QString artist);
    void titleChanged(QString title);
    void tempoChanged(int tempo);

private:
    QString m_artist;
    QString m_title;
    int m_tempo;
};

#endif // SONG_H
