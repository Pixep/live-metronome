#ifndef SETLIST_H
#define SETLIST_H

#include "songslistmodel.h"

#include <QObject>

class Setlist : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(SongsListModel* model READ model CONSTANT)

public:
    explicit Setlist(QObject *parent = 0);

    QString name() const { return m_name; }
    void setName(const QString& name);
    int count() const { return m_model.count(); }

    SongsListModel* model() { return &m_model; }
    const SongsListModel* modelConst() const { return &m_model; }

signals:
    void nameChanged();
    void countChanged();

private:
    QString m_name;
    SongsListModel m_model;
};

#endif // SETLIST_H
