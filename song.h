#ifndef SONG_H
#define SONG_H

#include <QObject>

class Song : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(int tempo READ tempo WRITE setTempo NOTIFY tempoChanged)
    Q_PROPERTY(int beatsPerMeasure READ beatsPerMeasure WRITE setBeatsPerMeasure NOTIFY beatsPerMeasureChanged)

public:
    explicit Song(QObject *parent = 0);
    explicit Song(const QString &artist, const QString &title, int tempo, int beatsPerMeasure = 4, QObject *parent = 0);

    QString artist() const { return m_artist; }
    void setArtist(const QString& artist);

    QString title() const { return m_title; }
    void setTitle(const QString& artist);

    int tempo() const { return m_tempo; }
    void setTempo(int tempo);

    int beatsPerMeasure() const { return m_beatsPerMeasure; }
    void setBeatsPerMeasure(int beats);

signals:
    void artistChanged(QString artist);
    void titleChanged(QString title);
    void tempoChanged(int tempo);
    void beatsPerMeasureChanged(int beats);

private:
    QString m_artist;
    QString m_title;
    int m_tempo;
    int m_beatsPerMeasure;
};

#endif // SONG_H
