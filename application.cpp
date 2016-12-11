#include "application.h"

#include <QLocale>
#include <QFile>
#include <QGuiApplication>
#include <QDebug>

#ifdef COMMERCIAL_VERSION
bool const Application::CommercialVersion = true;
#else
bool const Application::CommercialVersion = false;
#endif

Application* Application::m_instance = nullptr;

Application::Application(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

void Application::setLanguage(int languageCode)
{
    if (languageCode == static_cast<int>(QLocale::AnyLanguage))
        languageCode = static_cast<int>(QLocale::system().language());

    QString translationFile;
    QString languageString;
    QString defaultLanguage = "en-US";
    switch(languageCode)
    {
    case QLocale::Chinese:
        translationFile = "zn-CN";
        languageString = "中国";
        break;
    case QLocale::French:
        translationFile = "fr-FR";
        languageString = "Français";
        break;
    case QLocale::German:
        translationFile = "de-DE";
        languageString = "Deutsch";
        break;
    case QLocale::Spanish:
        translationFile = "es-ES";
        languageString = "Spanish";
        break;
    default:
        translationFile = defaultLanguage;
        languageCode = QLocale::English;
        languageString = "English";
        break;
    }

    QString prefix = ":/translations/";
    QString suffix = ".qm";
    translationFile = prefix + translationFile + suffix;
    if (!QFile::exists(translationFile))
    {
        qWarning() << "Translation file" << translationFile << "not found !";
        translationFile = defaultLanguage;
        translationFile = prefix + translationFile + suffix;
    }

    m_translator.load(translationFile);
    qApp->installTranslator(&m_translator);

    m_languageCode = languageCode;
    m_language = languageString;
    emit languageChanged();
}

int Application::maximumSongsPerPlaylist()
{
    if (isFreeVersion())
        return 30;

    return 50;
}

int Application::maximumPlaylists()
{
    if (isFreeVersion())
        return 1;

    return 20;
}

bool Application::allowPlaylists()
{
    return isCommercialVersion();
}

void Application::loadingFinished(QObject *object)
{
    if (object == nullptr)
        qFatal("Failed to load application");
}
