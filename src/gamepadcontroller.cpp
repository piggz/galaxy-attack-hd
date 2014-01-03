#include "gamepadcontroller.h"
#include <QDebug>

static screen_context_t _screen_ctx;
static int MAX_CONTROLLERS = 2;

// This macro provides error checking for all calls to libscreen APIs.
static int rc;

#define SCREEN_API(x, y) rc = x; \
    if (rc) fprintf(stderr, "\n%s in %s: %d", y, __FUNCTION__, errno)

GamepadController::GamepadController(QObject *parent) :
    QObject(parent)
{
    screen_create_context(&_screen_ctx, 0);
    bps_initialize();

    m_controllerIndex = 0;

    for (int i = 0; i < MAX_CONTROLLERS; ++i) {
        qDebug() << "init controller" << i;
        initController(&_controllers[i], i);
    }

    discoverControllers();
    rc = 0;
}

void GamepadController::initController(GameController* controller, int player)
{
    // Initialize controller values.
    controller->handle = 0;
    controller->type = 0;
    controller->analogCount = 0;
    controller->buttonCount = 0;
    controller->buttons = 0;
    controller->analog0[0] = controller->analog0[1] = controller->analog0[2] = 0;
    controller->analog1[0] = controller->analog1[1] = controller->analog1[2] = 0;
    sprintf(controller->deviceString, "Player %d: No device detected.", player + 1);
}

void GamepadController::discoverControllers()
{
    qDebug() << "discovering controllers";
    // Get an array of all available devices.
    int deviceCount;
    SCREEN_API(screen_get_context_property_iv(_screen_ctx, SCREEN_PROPERTY_DEVICE_COUNT, &deviceCount), "SCREEN_PROPERTY_DEVICE_COUNT");
    screen_device_t* devices = (screen_device_t*)calloc(deviceCount, sizeof(screen_device_t));
    SCREEN_API(screen_get_context_property_pv(_screen_ctx, SCREEN_PROPERTY_DEVICES, (void**)devices), "SCREEN_PROPERTY_DEVICES");

    qDebug() << "count" << deviceCount;

    // Scan the list for gamepad and joystick devices.
    int i;
    for (i = 0; i < deviceCount; i++) {
        int type;
        SCREEN_API(screen_get_device_property_iv(devices[i], SCREEN_PROPERTY_TYPE, &type), "SCREEN_PROPERTY_TYPE");

        qDebug() << i << ".1";
        if (!rc && (type == SCREEN_EVENT_GAMEPAD || type == SCREEN_EVENT_JOYSTICK)) {
            // Assign this device to control Player 1 or Player 2.
            GameController* controller = &_controllers[m_controllerIndex];
            controller->handle = devices[i];
            loadController(controller);

            // We'll just use the first compatible devices we find.
            m_controllerIndex++;
            if (m_controllerIndex == MAX_CONTROLLERS) {
                break;
            }
            qDebug() << i << ".3";
        }
    }
    qDebug() << "done:" << m_controllerIndex;

    free(devices);
}

void GamepadController::loadController(GameController* controller)
{
    qDebug() << "loadController.0";
    // Query libscreen for information about this device.
    SCREEN_API(screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_TYPE, &controller->type), "SCREEN_PROPERTY_TYPE");
    SCREEN_API(screen_get_device_property_cv(controller->handle, SCREEN_PROPERTY_ID_STRING, sizeof(controller->id), controller->id), "SCREEN_PROPERTY_ID_STRING");
    SCREEN_API(screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_BUTTON_COUNT, &controller->buttonCount), "SCREEN_PROPERTY_BUTTON_COUNT");

    // Check for the existence of analog sticks.
    if (!screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_ANALOG0, controller->analog0)) {
        ++controller->analogCount;
    }

    if (!screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_ANALOG1, controller->analog1)) {
        ++controller->analogCount;
    }

    if (controller->type == SCREEN_EVENT_GAMEPAD) {
        sprintf(controller->deviceString, "Gamepad device ID: %s", controller->id);
    } else {
        sprintf(controller->deviceString, "Joystick device: %s", controller->id);
    }
}

int GamepadController::numDevices()
{
    return m_controllerIndex;
}

void GamepadController::pollDevices()
{
    int i;
    for (i = 0; i < MAX_CONTROLLERS; i++) {
        GameController* controller = &_controllers[i];

        if (controller->handle) {
            // Get the current state of a gamepad device.
            SCREEN_API(screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_BUTTONS, &controller->buttons), "SCREEN_PROPERTY_BUTTONS");

            if (controller->analogCount > 0) {
                SCREEN_API(screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_ANALOG0, controller->analog0), "SCREEN_PROPERTY_ANALOG0");
            }

            if (controller->analogCount == 2) {
                SCREEN_API(screen_get_device_property_iv(controller->handle, SCREEN_PROPERTY_ANALOG1, controller->analog1), "SCREEN_PROPERTY_ANALOG1");
            }
        }
    }
}

int GamepadController::pollAndReadButtons(int controllerNum)
{
    pollDevices();
    if (controllerNum < m_controllerIndex) {
        GameController* controller = &_controllers[controllerNum];

        if (controller->handle) {
            return controller->buttons;
        }
    }

    return 0;
}
