#include "platform.h"

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

Platform* Platform::m_platformInstance = nullptr;

Platform::Platform(QObject *parent) : QObject(parent)
{
    m_platformInstance = this;
}

void Platform::setKeepScreenOn(bool screenOn)
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
#else
    return false;
#endif
}

bool Platform::isWindows() const
{
#ifdef Q_OS_WIN
    return true;
#else
    return false;
#endif
}

bool Platform::isAndroid() const
{
#ifdef Q_OS_ANDROID
    return true;
#else
    return false;
#endif
}

bool Platform::isCompiledWithMVS() const
{
#ifdef Q_CC_MSVC
    return true;
#else
    return false;
#endif
}

QString Platform::soundsPath() const
{
    if (isCompiledWithMVS())
        return "ms-appx:///assets/";
    else
        return "qrc:/sounds/";
}
