#include "platform.h"

Platform::Platform(QObject *parent) : QObject(parent)
{

}

bool Platform::isWindows() const
{
#ifdef Q_OS_WIN
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
