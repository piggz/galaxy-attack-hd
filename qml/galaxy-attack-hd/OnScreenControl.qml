import QtQuick 2.0

Item {

    signal moveLeft
    signal moveRight
    signal moveStop
    signal fire

    property bool leftHanded: false

    Component.onCompleted: {
        console.log("initiated OnScreenControl");
    }

    Item {
        id: dpad
        height: parent.height
        width: height * 2
        anchors.top: parent.top
        anchors.left: (leftHanded ? parent.right : parent.left)
        anchors.leftMargin: (leftHanded ? -width : 0)


        Image {
            id: buttonLeft
            source: "pics/arrow-left.svg"
            height: parent.height
            width: height
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Image {
            id: buttonRight
            source: "pics/arrow-right.svg"
            height: parent.height
            width: height
            anchors.top: parent.top
            anchors.left: buttonLeft.right
        }


        MultiPointTouchArea {
            id: touchJoystick
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 1

            touchPoints: [
                TouchPoint { id: tp1 }
            ]

            onPressed: {
              //console.log("pressed touch");
                if (leftButtonHit(tp1.x, tp1.y)) { //On Left
                    moveLeft();
                }

                if (rightButtonHit(tp1.x, tp1.y)) { //On Right
                    moveRight();
                }
            }

            onTouchUpdated:
            {
              //console.log("updated touch");
                if (tp1.pressed) {
                  if (leftButtonHit(tp1.x, tp1.y)) {
                    moveLeft();
                  }
                  if (rightButtonHit(tp1.x, tp1.y)) {
                    moveRight();
                  }
                } else {
                  moveStop()
                }
            }

            onReleased: {
              //console.log("released touch");
                moveStop();
            }


        }
    }

    Image {
        id: buttonFire
        source: "pics/button-fire.svg"
        height: parent.height
        width: height
        anchors.top: parent.top
        anchors.right: (leftHanded ? parent.left : parent.right)
        anchors.rightMargin: (leftHanded ? -width : 0)
        opacity: 0.8


        MultiPointTouchArea {
            id: touchFire

            anchors.fill: parent

            onPressed: {
                fire();
            }
        }

    }

    function leftButtonHit(tX, tY) {
        if (tX > buttonLeft.x && tX < buttonLeft.x + buttonLeft.width && tY > buttonLeft.y && tY < buttonLeft.y + buttonLeft.height) {
            return true;
        }
        return false;
    }

    function rightButtonHit(tX, tY) {
        if (tX > buttonRight.x && tX < buttonRight.x + buttonRight.width && tY > buttonRight.y && tY < buttonRight.y + buttonRight.height) {
            return true;
        }
        return false;
    }
}
