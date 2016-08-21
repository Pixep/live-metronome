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

void Application::initialize()
{
    QString translationFile;
    QString defaultLanguage = "en-US";
    switch(QLocale::system().language())
    {
    case QLocale::French:
        translationFile = "fr-FR";
        break;
    case QLocale::Spanish:
        translationFile = "es-ES";
        break;
    default:
        translationFile = defaultLanguage;
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
}

int Application::maximumSongsPerPlaylist()
{
    if (isFreeVersion())
        return 7;

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
