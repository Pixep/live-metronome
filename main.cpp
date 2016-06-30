#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "platform.h"
#include "usersettings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Song>("Metronome", 1, 0, "Song");

    Platform platform;
    UserSettings userSettings;
    engine.rootContext()->setContextProperty("platform", &platform);
    engine.rootContext()->setContextProperty("userSettings", &userSettings);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
