#include "platformattributes.h"

PlatformAttributes::PlatformAttributes() :
    m_orientation(0),
    m_dpi(17)
{
}

void PlatformAttributes::setOrientation(int newOrientation)
{
    if (m_orientation == newOrientation)
        return;

    m_orientation = newOrientation;
    emit orientationChanged();
}

void PlatformAttributes::setDpi(double newDpi)
{
    if (m_dpi == newDpi)
        return;

    m_dpi = newDpi;
    emit dpiChanged();
}
