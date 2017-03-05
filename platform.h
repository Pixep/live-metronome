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
    Q_PROPERTY(PlatformAttributes* simulation READ simulationAttributes CONSTANT)
    Q_PROPERTY(bool simulationMode READ isInSimulationMode CONSTANT)

public:
    explicit Platform(QObject *parent = 0);
    static Platform* get() { return m_platformInstance; }

    PlatformAttributes* simulationAttributes() { return &m_platformAttributes; }

    static bool isWindows();
    static bool isLinux();
    static bool isAndroid();
    static bool isWindowsPhone();
    static bool isCompiledWithMVS();
    static bool isInSimulationMode() { return isWindows() || isLinux(); }

    static QString soundsPath();

public slots:
    bool setKeepScreenOn(bool screenOn);

private:
    static Platform* m_platformInstance;

    PlatformAttributes m_platformAttributes;
};

#endif // PLATFORM_H
