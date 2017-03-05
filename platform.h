#ifndef PLATFORM_H
#define PLATFORM_H

#include <QObject>
#include "platformattributes.h"

class Platform : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isWindows READ isWindows CONSTANT)
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT)
    Q_PROPERTY(QString soundsPath READ soundsPath CONSTANT)
    Q_PROPERTY(PlatformAttributes* debug READ debugAttributes CONSTANT)

public:
    explicit Platform(QObject *parent = 0);
    static Platform* get() { return m_platformInstance; }

    PlatformAttributes* debugAttributes() { return &m_platformAttributes; }

    static bool isWindows();
    static bool isAndroid();
    static bool isCompiledWithMVS();
    static QString soundsPath();

public slots:
    bool setKeepScreenOn(bool screenOn);

private:
    static Platform* m_platformInstance;

    PlatformAttributes m_platformAttributes;
};

#endif // PLATFORM_H
