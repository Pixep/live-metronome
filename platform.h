#ifndef PLATFORM_H
#define PLATFORM_H

#include <QObject>

class Platform : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isWindows READ isWindows CONSTANT)
    Q_PROPERTY(QString soundsPath READ soundsPath CONSTANT)

public:
    explicit Platform(QObject *parent = 0);

    bool isWindows() const;
    bool isCompiledWithMVS() const;
    QString soundsPath() const;

signals:

public slots:
};

#endif // PLATFORM_H
