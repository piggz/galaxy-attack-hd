import QtQuick 2.0

Item {
    property bool gpLeftPressed: false
    property bool gpRightPressed: false
    property bool gpUpPressed: false
    property bool gpDownPressed: false
    property bool gpFirePressed: false
    property bool gpMenuPressed: false
    property bool gpEnabled: GamepadController.numDevices > 0
    property bool gpUseInternalTimer: false

    signal leftChanged(var pressed)
    signal rightChanged(var pressed)
    signal upChanged(var pressed)
    signal downChanged(var pressed)
    signal fireChanged(var pressed)
    signal menuChanged(var pressed)
    signal noDirection

    Timer {
        id: pollGamepad
        interval: 32
        running: gpEnabled && gpUseInternalTimer
        repeat: true
        onTriggered: {
            poll();
        }
    }

    function poll() {
        if (gpEnabled) {
            var buttonState = GamepadController.pollAndReadButtons(0);
            if (buttonState & (1 << 18)) { //left
                gpLeftPressed = true;
            } else {
                gpLeftPressed = false;
            }

            if (buttonState & (1 << 19)) { //right
                gpRightPressed = true;
            } else {
                gpRightPressed = false;
            }

            if (buttonState & (1 << 16)) { //up
                gpUpPressed = true;
            } else {
                gpUpPressed = false;
            }

            if (buttonState & (1 << 17)) { //down
                gpDownPressed = true;
            } else {
                gpDownPressed = false;
            }

            if ((buttonState & (1 << 0)) ||  (buttonState & (1 << 1)) || (buttonState & (1 << 3)) ||  (buttonState & (1 << 4))){ //fire a,b,x or y
                gpFirePressed = true;
            } else {
                gpFirePressed = false;
            }

            if ((buttonState & (1 << 7)) ||  (buttonState & (1 << 8))) { //menu2/menu3
                gpMenuPressed = true;
            } else {
                gpMenuPressed = false;
            }

            if (!(buttonState & (1 << 18)) && !(buttonState & (1 << 19))) { //no direction
                noDirection();
            }
        }
    }

    onGpLeftPressedChanged: {
        leftChanged(gpLeftPressed);
    }
    onGpRightPressedChanged: {
        rightChanged(gpRightPressed);
    }
    onGpUpPressedChanged: {
        upChanged(gpUpPressed);
    }
    onGpDownPressedChanged: {
        downChanged(gpDownPressed);
    }
    onGpFirePressedChanged: {
        fireChanged(gpFirePressed);
    }
    onGpMenuPressedChanged: {
        menuChanged(gpMenuPressed);
    }




}
