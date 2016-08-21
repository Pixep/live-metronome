#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QTranslator>

class Application : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isFreeVersion READ isFreeVersion CONSTANT)
    Q_PROPERTY(bool isCommercialVersion READ isCommercialVersion CONSTANT)
    Q_PROPERTY(int maximumSongsPerPlaylist READ maximumSongsPerPlaylist CONSTANT)
    Q_PROPERTY(int maximumPlaylists READ maximumPlaylists CONSTANT)
    Q_PROPERTY(int allowPlaylists READ allowPlaylists CONSTANT)

public:
    explicit Application(QObject *parent = 0);
    static Application* get() { return m_instance; }

    void initialize();

    static bool isCommercialVersion() { return CommercialVersion; }
    static bool isFreeVersion() { return !isCommercialVersion(); }

    static int maximumSongsPerPlaylist();
    static int maximumPlaylists();
    static bool allowPlaylists();

private:
    static Application* m_instance;
    static const bool CommercialVersion;

    QTranslator m_translator;
};

#endif // APPLICATION_H
