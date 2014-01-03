#ifndef GAMEPADCONTROLLER_H
#define GAMEPADCONTROLLER_H

#include <QObject>
#ifdef Q_OS_BLACKBERRY
#include <bps/navigator.h>
#include <bps/bps.h>
#include <bps/event.h>
#include <bps/navigator.h>
#include <bps/screen.h>

#include <png.h>
#include <errno.h>

#include <screen/screen.h>
#endif

// Structure representing a game controller.
typedef struct GameController_t {
    // Static device info.
    screen_device_t handle;
    int type;
    int analogCount;
    int buttonCount;
    char id[64];

    // Current state.
    int buttons;
    int analog0[3];
    int analog1[3];

    // Text to display to the user about this controller.
    char deviceString[256];
    char buttonsString[128];
    char analog0String[128];
    char analog1String[128];
} GameController;

// Controller information.

class GamepadController : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(int numDevices READ numDevices CONSTANT);

    explicit GamepadController(QObject *parent = 0);
    Q_INVOKABLE int pollAndReadButtons(int controllerNum);

signals:

private:
    void pollDevices();
    void initController(GameController* controller, int player);
    void discoverControllers();
    void loadController(GameController* controller);
    int m_controllerIndex;

    GameController _controllers[2];
    int numDevices();
};

#endif // GAMEPADCONTROLLER_H
