import QtQuick 2.0

import "sizer.js" as Sizer;

Rectangle {
    id: menupanel

    property bool onScreen: false
    property bool animating: !((y === 0) || ( y  == (-height - 5)))
    property int selectedItem: 0
    property color foreground: "#7DF9FF"

    signal exitClicked

    height: text2.y + text2.height + 50;
    width:  text2.width + 40
    color:  "black"
    border.color: foreground
    border.width: 5
    radius: 10

    y: onScreen?0:(-height - 5)
    x: 0

    Behavior on y {
        NumberAnimation {duration: 400}
    }

    //Dummy mouse area to stop events being passed through
    MouseArea {
        anchors.fill: parent
    }

    Text {
        id: text1
        color: foreground
        text: "Galaxy Attack HD"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        font.pixelSize: Sizer.largeFontSize()
        MouseArea {
            anchors.fill: parent;
            onClicked: Qt.openUrlExternally(text2.text);
        }
    }

    MenuItem {
        id: settingsItem
        height: Helper.mmToPixels(6);
        menuImage: "pics/options.png"
        menuText: "Settings"
        menuColor: selectedItem == 1 ? "white" : foreground
        anchors.top: text1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 30

        onMenuItemClicked: {
            menupanel.onScreen = false;
            settingspanel.onScreen = !settingspanel.onScreen;
        }
    }

    MenuItem {
        id: hiScoreItem
        height: Helper.mmToPixels(6);
        menuImage: "pics/hiscore.png"
        menuText: "Hi Scores"
        menuColor: selectedItem == 2 ? "white" : foreground
        anchors.top: settingsItem.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 30

        onMenuItemClicked: {
            menupanel.onScreen = false;
            hiscorepanel.onScreen = !hiscorepanel.onScreen;
        }
    }

    MenuItem {
        id: globalScoreItem
        height: Helper.mmToPixels(6);
        menuImage: "pics/globalscore.png"
        menuText: "Global Scores"
        menuColor: selectedItem == 3 ? "white" : foreground
        anchors.top: hiScoreItem.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 30

        onMenuItemClicked: {
            menupanel.onScreen = false;
            scoreloopBoard.onScreen = !scoreloopBoard.onScreen;
        }
    }

    MenuItem {
        id: exitItem
        height: Helper.mmToPixels(6);
        menuImage: "pics/x.svg"
        menuText: "Exit"
        menuColor: selectedItem == 4 ? "white" : foreground
        anchors.top: globalScoreItem.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 30

        onMenuItemClicked: {
            exitClicked();
        }
    }


    Text {
        id: text2
        color: selectedItem == 5 ? "white" : foreground
        text: "http://www.piggz.co.uk?page=spaceinvaders"
        anchors.top: exitItem.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        font.pixelSize: Sizer.smallFontSize()

        MouseArea {
            anchors.fill: parent;
            onClicked: Qt.openUrlExternally(text2.text);
        }
    }

    Text {
        id: textdonate
        color: selectedItem == 6 ? "white" : foreground
        text: "Donate"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        font.pixelSize: Sizer.largeFontSize()
        anchors.bottomMargin: 5
        anchors.rightMargin: 5
        MouseArea {
            anchors.fill: parent;
            onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVTJ5JNBQA72A");
        }
    }

    function downPressed() {
        selectedItem++;
        if (selectedItem > 6) {
            selectedItem = 1;
        }
    }

    function upPressed() {
        selectedItem--;
        if (selectedItem < 1) {
            selectedItem = 6;
        }
    }

    function firePressed() {
        if (selectedItem == 1) {
            settingsItem.click();
        }
        if (selectedItem == 2) {
            hiScoreItem.click();
        }
        if (selectedItem == 3) {
            globalScoreItem.click();
        }
        if (selectedItem == 4) {
            exitItem.click();
        }
        if (selectedItem == 5) {
            Qt.openUrlExternally(text2.text)
        }
        if (selectedItem == 6) {
            Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVTJ5JNBQA72A");
        }
    }
}
