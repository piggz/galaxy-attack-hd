#include "BunkerFactory.h"
#include <QDebug>
#include <QtQuick/QQuickPaintedItem>

BunkerFactory::BunkerFactory(QObject *parent) :
    QObject(parent)
{
}

void BunkerFactory::createBunker(int x, int y, QQuickItem *parent)
{
    qDebug() << "BunkerFactory::createBunker";
    qDebug() << x << y << parent->objectName();
}
