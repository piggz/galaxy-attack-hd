import QtQuick 2.0

import "sizer.js" as Sizer;

Item {
    id: infoDialog

    property bool onScreen
    property color foreground: "#7DF9FF"

    signal clickedClose

    width: parent.width / 2
    height: parent.height - 20
    scale:  onScreen ? 1 : 0
    visible: scale > 0;

    Behavior on scale {
        NumberAnimation {duration: 1000; easing.type: Easing.OutBounce}
    }

    Rectangle {

        anchors.fill: parent
        color: "#000000"
        border.width: 3
        border.color: foreground
        radius: 10

        MouseArea {
            //Fake area to stop click throughs
            anchors.fill: parent
        }

        Text {
            id: text1
            color: foreground
            text: "Ship Control: Tilt device or \nOn-Screen controls or\nGamepad left-right\n\nFire: Tap Screen or\nGamepad a/select\n\nOptions: Down arrow in top left or\nGamepad Start/Menu button\n\nExit: X in menu\n\nSupport: adam@piggz.co.uk"
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.pixelSize: Sizer.smallFontSize()
        }

        Rectangle {
            id: rectangle3

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 20
            anchors.rightMargin: 20

            width: txtClose.width + 30
            height: txtClose.height + 30
            color: "#000000"
            border.color: foreground
            border.width: 3

            MouseArea {
                id:areaClose
                anchors.fill: parent
            }

            Text {
                id: txtClose
                text: "Close"
                anchors.centerIn: parent
                color: foreground
                font.pixelSize: Sizer.largeFontSize()
            }
        }


    }

    Component.onCompleted: {
        areaClose.clicked.connect(clickedClose);
    }


}
