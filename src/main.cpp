#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "platform.h"
#include "usersettings.h"
#include "metronome.h"
#include "application.h"
#include "setlist.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Song>("LiveMetronome", 1, 0, "Song");
    qmlRegisterType<Setlist>("LiveMetronome", 1, 0, "Setlist");
    qmlRegisterType<Metronome>("LiveMetronome", 1, 0, "Metronome");

    Platform platform;
    Application application;
    UserSettings userSettings(engine.offlineStoragePath());
    QObject::connect(&userSettings, &UserSettings::preferredLanguageChanged, &application, &Application::setLanguage);

    // Root context
    engine.rootContext()->setContextProperty("platform", &platform);
    engine.rootContext()->setContextProperty("application", &application);
    engine.rootContext()->setContextProperty("userSettings", &userSettings);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &application, &Application::loadingFinished);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
