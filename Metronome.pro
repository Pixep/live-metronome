TEMPLATE = app

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    usersettings.cpp \
    song.cpp \
    platform.cpp \
    metronome.cpp \
    audiostream.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

sounds.source = sounds
DEPLOYMENTFOLDERS += sounds

OTHER_FILES += qml/*.qml

HEADERS += \
    usersettings.h \
    song.h \
    platform.h \
    metronome.h \
    audiostream.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/com/livemetronome/MainActivity.java

android {
    QT += androidextras
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
