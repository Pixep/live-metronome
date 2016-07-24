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

    qmlRegisterType<Song>("LiveMetronome", 1, 0, "Song");
    qmlRegisterType<Metronome>("LiveMetronome", 1, 0, "Metronome");

    Platform platform;
    UserSettings userSettings(engine.offlineStoragePath());
    engine.rootContext()->setContextProperty("platform", &platform);
    engine.rootContext()->setContextProperty("userSettings", &userSettings);

#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("isAndroid", QVariant(true));
#else
    engine.rootContext()->setContextProperty("isAndroid", QVariant(false));
#endif

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
