#include "setlist.h"

Setlist::Setlist(QObject *parent) : QObject(parent)
{
    connect(model(), &SongsListModel::countChanged, this, &Setlist::countChanged);
}

void Setlist::setName(const QString &newName)
{
    if (newName == name())
        return;

    m_name = newName;
    emit nameChanged();
}
