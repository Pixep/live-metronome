#ifndef PLATFORMATTRIBUTES_H
#define PLATFORMATTRIBUTES_H

#include <QObject>

class PlatformAttributes : public QObject {
    Q_OBJECT

    Q_PROPERTY(int orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)
    Q_PROPERTY(double dpi READ dpi WRITE setDpi NOTIFY dpiChanged)
    Q_PROPERTY(double pixelDensity READ pixelDensity NOTIFY dpiChanged)

public:
    explicit PlatformAttributes();

    int orientation() const { return m_orientation; }
    void setOrientation(int newOrientation);

    double dpi() const { return m_dpi; }
    double pixelDensity() const { return m_dpi / 25.4; }
    void setDpi(double newDpi);

signals:
    void orientationChanged();
    void dpiChanged();
    void pixelDensityChanged();

private:
    int m_orientation;
    double m_dpi;
};

#endif // PLATFORMATTRIBUTES_H
