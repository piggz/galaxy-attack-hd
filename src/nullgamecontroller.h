#ifndef NULLGAMECONTROLLER_H
#define NULLGAMECONTROLLER_H

#include <QObject>

class NullGameController : public QObject
{
    Q_OBJECT
public:
    explicit NullGameController(QObject *parent = 0);
    Q_PROPERTY(int numDevices READ numDevices CONSTANT);

signals:

private:
    int numDevices();
};

#endif // NULLGAMECONTROLLER_H
