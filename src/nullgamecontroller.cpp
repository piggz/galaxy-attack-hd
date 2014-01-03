#include "nullgamecontroller.h"

NullGameController::NullGameController(QObject *parent) :
    QObject(parent)
{
}

int NullGameController::numDevices()
{
    return 0;
}
