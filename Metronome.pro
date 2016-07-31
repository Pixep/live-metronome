TEMPLATE = app

DEFINES += \
    COMMERCIAL_VERSION

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    usersettings.cpp \
    song.cpp \
    platform.cpp \
    metronome.cpp \
    audiostream.cpp \
    songslistmodel.cpp \
    application.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

sounds.source = sounds
DEPLOYMENTFOLDERS += sounds

OTHER_FILES += \
    qml/* \
    qml/controls/* \
    qml/components/* \
    qml/dialogs/* \
    qml/pages/* \
    qml/pages/MainPage/* \
    qml/pages/MoveSongsPage/* \
    qml/images/*

HEADERS += \
    usersettings.h \
    song.h \
    platform.h \
    metronome.h \
    audiostream.h \
    songslistmodel.h \
    application.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/com/livemetronome/MainActivity.java \
    android/src/com/livemetronome/PlatformControlRunnable.java

android {
    QT += androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
