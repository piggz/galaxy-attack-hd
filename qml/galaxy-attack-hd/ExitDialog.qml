import QtQuick 2.0

import "sizer.js" as Sizer;

Item {
    id: exitDialog

    property bool onScreen
    property color foreground: "#7DF9FF"
    property int selectedItem: 0

    width: text1.width + 50
    height: 250


    scale:  onScreen ? 1 : 0
    visible: scale > 0;

    Behavior on scale {
        NumberAnimation {duration: 1000; easing.type: Easing.OutBounce}
    }

    signal clickedYes
    signal clickedNo

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
            x: 18
            y: 25
            color: foreground
            text: "Are you sure you want to exit?"
            font.pixelSize: Sizer.largeFontSize()
        }

        Rectangle {
            id: rectangle1

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 20
            anchors.leftMargin: 20

            width: txtNo.width + 30
            height: txtNo.height + 30
            color: selectedItem === 1 ? foreground : "black"
            border.width: 3
            border.color: foreground

            MouseArea {
                id:areaNo
                anchors.fill: parent

            }

            Text {
                id: txtNo
                text: "No"
                font.pixelSize: Sizer.largeFontSize()
                anchors.centerIn: parent
                color: selectedItem === 1 ? "black" : foreground
            }
        }

        Rectangle {
            id: rectangle2

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 20
            anchors.rightMargin: 20

            width: txtYes.width + 30
            height: txtYes.height + 30
            color: selectedItem === 2 ? foreground : "black"
            border.color: foreground
            border.width: 3

            MouseArea {
                id:areaYes
                anchors.fill: parent
            }

            Text {
                id: txtYes
                text: "Yes"
                font.pixelSize: Sizer.largeFontSize()
                anchors.centerIn: parent
                color: selectedItem === 2 ? "black" : foreground
            }
        }
    }

    Component.onCompleted: {
        areaYes.clicked.connect(clickedYes);
        areaNo.clicked.connect(clickedNo);
    }

    function firePressed() {
        if (selectedItem === 2) {
            clickedYes();
        } else {
            clickedNo();
        }
    }

    function rightPressed() {
        selectedItem++;
        if (selectedItem > 2) {
            selectedItem = 1;
        }
    }

    function leftPressed() {
        selectedItem--;
        if (selectedItem < 1) {
            selectedItem = 2;
        }
    }
}
