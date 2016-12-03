#ifndef PLATFORM_H
#define PLATFORM_H

#include <QObject>

class Platform : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isWindows READ isWindows CONSTANT)
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT)
    Q_PROPERTY(QString soundsPath READ soundsPath CONSTANT)

public:
    explicit Platform(QObject *parent = 0);
    static Platform* get() { return m_platformInstance; }

    static bool isWindows();
    static bool isAndroid();
    static bool isCompiledWithMVS();
    static QString soundsPath();

public slots:
    bool setKeepScreenOn(bool screenOn);

private:
    static Platform* m_platformInstance;
};

#endif // PLATFORM_H
