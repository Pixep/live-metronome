#include "application.h"

#ifdef COMMERCIAL_VERSION
bool const Application::CommercialVersion = true;
#else
bool const Application::CommercialVersion = false;
#endif

Application* Application::m_instance = nullptr;

Application::Application(QObject *parent) : QObject(parent)
{
    m_instance = this;
}

int Application::maximumSongsPerPlaylist()
{
    if (isFreeVersion())
        return 7;

    return 50;
}

int Application::maximumPlaylists()
{
    if (isFreeVersion())
        return 1;

    return 20;
}

bool Application::allowPlaylists()
{
    return isCommercialVersion();
}
