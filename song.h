#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(int tempo READ tempo WRITE setTempo NOTIFY tempoChanged)

public:
    explicit Song(QObject *parent = 0);
    explicit Song(const QString &artist, const QString &title, int tempo, QObject *parent = 0);

    QString artist() const { return m_artist; }
    void setArtist(const QString& artist);

    QString title() const { return m_title; }
    void setTitle(const QString& artist);

    int tempo() const { return m_tempo; }
    void setTempo(int tempo);

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
