#include "platform.h"

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Platform* Platform::m_platformInstance = nullptr;

Platform::Platform(QObject *parent) : QObject(parent)
{
    m_platformInstance = this;
}

bool Platform::setKeepScreenOn(bool screenOn)
{
#ifdef Q_OS_ANDROID
    if (screenOn)
        QAndroidJniObject::callStaticMethod<void>("com.livemetronome.MainActivity",
                                                  "enableKeepScreenOn",
                                                  "()V");
    else
        QAndroidJniObject::callStaticMethod<void>("com.livemetronome.MainActivity",
                                                  "disableKeepScreenOn",
                                                  "()V");

    return true;
#else
    Q_UNUSED(screenOn)
    return false;
#endif
}

bool Platform::isWindows()
{
#ifdef Q_OS_WIN
    return true;
#else
    return false;
#endif
}

bool Platform::isLinux()
{
    if (isAndroid())
        return false;

#ifdef Q_OS_LINUX
    return true;
#else
    return false;
#endif
}

bool Platform::isAndroid()
{
    if (isInSimulationMode())
        return true;

#ifdef Q_OS_ANDROID
    return true;
#else
    return true;
#endif
}

bool Platform::isWindowsPhone()
{
#ifdef Q_OS_WINRT
    return true;
#else
    return false;
#endif
}

bool Platform::isCompiledWithMVS()
{
#ifdef Q_CC_MSVC
    return true;
#else
    return false;
#endif
}

QString Platform::soundsPath()
{
    if (isCompiledWithMVS())
        return "ms-appx:///assets/";
    else
        return "qrc:/sounds/";
}
