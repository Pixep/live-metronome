#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QTranslator>
#include <QRect>
#include <QQuickWindow>

class Application : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int languageCode READ languageCode NOTIFY languageChanged)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)
    Q_PROPERTY(QString trBind READ trBind NOTIFY languageChanged)
    Q_PROPERTY(bool isFreeVersion READ isFreeVersion CONSTANT)
    Q_PROPERTY(bool isCommercialVersion READ isCommercialVersion CONSTANT)
    Q_PROPERTY(int maximumSongsPerPlaylist READ maximumSongsPerPlaylist CONSTANT)
    Q_PROPERTY(int maximumPlaylists READ maximumPlaylists CONSTANT)
    Q_PROPERTY(int allowSetlists READ allowSetlists CONSTANT)

    Q_PROPERTY(QQuickWindow *window READ window WRITE setWindow NOTIFY windowChanged)

public:
    explicit Application(QObject *parent = 0);
    static Application* get() { return m_instance; }

    void initialize();

    int languageCode() { return m_languageCode; }
    QString language() { return m_language; }
    QString trBind() { return QString(); }

    static bool isCommercialVersion() { return CommercialVersion; }
    static bool isFreeVersion() { return !isCommercialVersion(); }

    static int maximumSongsPerPlaylist();
    static int maximumPlaylists();
    static bool allowSetlists();

    QQuickWindow* window() const { return m_window; }

public slots:
    void loadingFinished(QObject *object);
    void setLanguage(int languageCode);

    void setWindow(QQuickWindow *window);

signals:
    void languageChanged();
    void windowChanged(QQuickWindow *window);

private:
    static Application* m_instance;
    static const bool CommercialVersion;

    QTranslator m_translator;
    int m_languageCode;
    QString m_language;
    QQuickWindow *m_window;
};

#endif // APPLICATION_H
