TEMPLATE = app

# Application type
DEFINES += COMMERCIAL_VERSION

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    usersettings.cpp \
    song.cpp \
    platform.cpp \
    metronome.cpp \
    audiostream.cpp \
    songslistmodel.cpp \
    application.cpp \
    setlist.cpp \
    platformattributes.cpp

RESOURCES += qml.qrc \
    translations.qrc \
    audio.qrc

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
    qml/pages/SetlistPage/* \
    qml/images/*

HEADERS += \
    usersettings.h \
    song.h \
    platform.h \
    metronome.h \
    audiostream.h \
    songslistmodel.h \
    application.h \
    setlist.h \
    platformattributes.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/com/livemetronome/MainActivity.java \
    android/src/com/livemetronome/PlatformControlRunnable.java \
    qml/ApplicationStyle.qml \
    qml/components/ApplicationMenu.qml \
    qml/controls/MenuItem.qml \
    qml/MainMenu.qml \
    qml/dialogs/EditDialog.qml \
    qml/pages/SetlistPage/SetlistDelegate.qml \
    qml/pages/SetlistPage/SetlistActionDialog.qml \
    qml/pages/SettingsPage.qml \
    android/res/values/appstyle.xml \
    qml/debug/DebugWindow.qml

android {
    QT += androidextras
}

# Translations
TRANSLATIONS = \
    translations/en-US.ts \
    translations/fr-FR.ts \
    translations/es-ES.ts \
    translations/zn-CN.ts \
    translations/de-DE.ts

lupdate-only {
    SOURCES += $$OTHER_FILES
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
