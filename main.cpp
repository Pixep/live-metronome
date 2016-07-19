#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include "platform.h"
#include "usersettings.h"
#include "metronome.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Song>("com.livemetronome", 1, 0, "Song");
    qmlRegisterType<Metronome>("com.livemetronome", 1, 0, "Metronome");

    Platform platform;
    UserSettings userSettings(engine.offlineStoragePath());
    engine.rootContext()->setContextProperty("platform", &platform);
    engine.rootContext()->setContextProperty("userSettings", &userSettings);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
