#ifndef BUNKERFACTORY_H
#define BUNKERFACTORY_H

#include <QObject>

class QQuickItem;

class BunkerFactory : public QObject
{
    Q_OBJECT
public:
    explicit BunkerFactory(QObject *parent = 0);

signals:

public slots:
    void createBunker(int x, int y, QQuickItem *parent);

};

#endif // BUNKERFACTORY_H
