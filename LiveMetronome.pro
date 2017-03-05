TEMPLATE = app

# Application type
DEFINES += COMMERCIAL_VERSION

QT += qml quick multimedia
CONFIG += c++11

include(deployment.pri)

SOURCES += \
    src/main.cpp \
    src/usersettings.cpp \
    src/song.cpp \
    src/platform.cpp \
    src/metronome.cpp \
    src/audiostream.cpp \
    src/songslistmodel.cpp \
    src/application.cpp \
    src/setlist.cpp \
    src/platformattributes.cpp

HEADERS += \
    src/usersettings.h \
    src/song.h \
    src/platform.h \
    src/metronome.h \
    src/audiostream.h \
    src/songslistmodel.h \
    src/application.h \
    src/setlist.h \
    src/platformattributes.h

RESOURCES += \
    qml.qrc \
    translations.qrc \
    audio.qrc

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
    qml/debug/*

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

#------------------------------------------------------
# Add translation files
TRANSLATIONS = \
    translations/en-US.ts \
    translations/fr-FR.ts \
    translations/es-ES.ts \
    translations/zn-CN.ts \
    translations/de-DE.ts

# Ensure QML strings are translated as well
lupdate-only {
    SOURCES += $$QML_FILES
}

# Add images after translations to avoid having images in sources
OTHER_FILES += \
    qml/images/* \
    qml/images/black/*

#------------------------------------------------------
# Android specific
android {
    QT += androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
