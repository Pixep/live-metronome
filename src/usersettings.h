#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include "song.h"
#include "songslistmodel.h"

#include <QObject>
#include <QQmlListProperty>
#include <QLocale>

class Setlist;

class UserSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Setlist* setlist READ setlist NOTIFY setlistChanged)
    Q_PROPERTY(SongsListModel* songsModel READ songsModel NOTIFY setlistChanged)
    Q_PROPERTY(SongsListModel* songsMoveModel READ songsMoveModel CONSTANT)
    Q_PROPERTY(QQmlListProperty<Setlist> setlists READ setlistsProperty NOTIFY setlistsChanged)
    Q_PROPERTY(int setlistIndex READ setlistIndex NOTIFY setlistIndexChanged)
    Q_PROPERTY(QStringList tickSoundsAvailable READ tickSoundsAvailable CONSTANT)
    Q_PROPERTY(QString tickSoundName READ tickSoundName NOTIFY tickSoundsChanged)
    Q_PROPERTY(bool canAddSong READ canAddSong NOTIFY canAddSongChanged)

private:
    struct TickSoundResource {
        TickSoundResource() {}
        TickSoundResource(const QString& pName, const QString& pHighTickFile, const QString& pLowTickFile)
            : name(pName), highTick(pHighTickFile), lowTick(pLowTickFile) {}
        bool isNull() const { return name.isNull(); }
        QString name;
        QString highTick;
        QString lowTick;
    };

signals:
    void settingsModified();
    void songAdded();
    void songRemoved(int removedIndex);
    void canAddSongChanged();
    void allSongsRemoved();
    void songModified();
    void setlistChanged();
    void setlistsChanged();
    void setlistIndexChanged();
    void preferredLanguageChanged(int language);
    void tickSoundsChanged(const QString& highTickFile, const QString& lowTickFile);

public:
    explicit UserSettings(const QString& settings, QObject *parent = 0);

    QStringList tickSoundsAvailable();
    QQmlListProperty<Song> songList();
    Setlist* setlist() { return m_currentSetlist; }
    SongsListModel* songsModel();
    const SongsListModel *songsModelConst() const;
    SongsListModel* songsMoveModel() { return &m_songsMoveModel; }
    QVector<Setlist*> setlists() { return m_setlists; }
    QVector<const Setlist*> setlistsConst() const;

    QLocale::Language preferredLanguage() const { return m_preferredLanguage; }
    const TickSoundResource tickSound() const { return m_tickSoundFiles.value(m_currentTickSoundIndex); }

public slots:
    void resetToDefault();
    bool setJsonSettings(const QString& json);
    QString jsonSettings() const;

    void addTickSound(const QString &name, const QString &highTick, const QString &lowTick);
    void setTickSound(int index);
    int tickSoundIndex() const { return m_currentTickSoundIndex; }
    QString tickSoundName() const { return tickSound().name; }
    QString highTickSoundFile() const { return tickSound().highTick; }
    QString lowTickSoundFile() const { return tickSound().lowTick; }
    QString highTickSoundUrl() const { return "qrc" + tickSound().highTick; }
    QString lowTickSoundUrl() const { return "qrc" + tickSound().lowTick; }

    bool setSong(int index, const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool addSong(const QString& title, const QString& artist, int tempo, int beatsPerMeasure);
    bool canAddSong(SongsListModel* model = nullptr) const;
    bool removeSong(int index);
    bool removeAllSongs();

    bool moveSong(int index, int destinationIndex);

    bool addSetlist(const QString& name);
    bool removeSetlist(int index);
    bool setCurrentSetlist(int index);
    int currentSetlistIndex();
    bool setSetlistName(int index, const QString& name);
    bool setCurrentSetlistName(const QString& name);
    int setlistsCount() const { return m_setlists.count(); }
    int setlistIndex() const;

    bool commitSongMoves();
    bool discardSongMoves();

    void setPreferredLanguage(int language);

private:
    bool setTickSound_internal(int index);
    bool addSong_internal(const QString& title, const QString& artist, int tempo, int beatsPerMeasure, Setlist *setlist = nullptr);
    bool setSong_internal(int index, const QString& title, const QString& artist, int tempo, int beatsPerMeasure, Setlist *setlist = nullptr);
    Setlist *addSetlist_internal(QString name);
    bool removeAllPlaylists_internal();
    bool setCurrentSetlist_internal(int index);

    QQmlListProperty<Setlist> setlistsProperty();
    static int setlistsProperty_count(QQmlListProperty<Setlist> *listProperty);
    static Setlist* setlistsProperty_at(QQmlListProperty<Setlist> *listProperty, int index);

private:
    Setlist* m_currentSetlist;
    QVector<Setlist*> m_setlists;
    QLocale::Language m_preferredLanguage;

    QVector<TickSoundResource> m_tickSoundFiles;
    int m_currentTickSoundIndex;

    SongsListModel m_songsMoveModel;
    QString m_storagePath;
};

namespace Setting {
    const QString CurrentSetlist = "currentSetlist";
    const QString TickSound = "tickSound";
}

#endif // USERSETTINGS_H
