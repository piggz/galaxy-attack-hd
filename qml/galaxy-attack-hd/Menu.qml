import QtQuick 2.0

import "sizer.js" as Sizer;

Rectangle {
    id: menupanel

    property bool onScreen: false
    property bool animating: !((y === 0) || ( y  == (-height - 5)))
    property int selectedItem: 0
    property color foreground: "#7DF9FF"
    property int maxItem: ANDROID_MARKET === "GOOGLE" ? 7 : 5

    signal exitClicked

    height: colMenu.height + Sizer.largeFontSize() / 3
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

    Column {
        id: colMenu
        spacing: Sizer.largeFontSize() / 3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Sizer.largeFontSize() / 3

        Text {
            id: text1
            color: foreground
            text: "Galaxy Attack HD"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Sizer.largeFontSize()
            MouseArea {
                anchors.fill: parent;
                onClicked: Qt.openUrlExternally(text2.text);
            }
        }

        MenuItem {
            id: settingsItem
            height: Helper.mmToPixels(8);
            menuImage: "pics/options.png"
            menuText: "Settings"
            menuColor: selectedItem == 1 ? "white" : foreground
            //            anchors.top: text1.bottom
            //            anchors.left: parent.left
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            //            anchors.leftMargin: Sizer.largeFontSize() / 3

            onMenuItemClicked: {
                menupanel.onScreen = false;
                settingspanel.onScreen = !settingspanel.onScreen;
            }
        }

        MenuItem {
            id: hiScoreItem
            height: Helper.mmToPixels(8);
            menuImage: "pics/hiscore.png"
            menuText: "Hi Scores"
            menuColor: selectedItem == 2 ? "white" : foreground
            //            anchors.top: settingsItem.bottom
            //            anchors.left: parent.left
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            //            anchors.leftMargin: Sizer.largeFontSize() / 3

            onMenuItemClicked: {
                menupanel.onScreen = false;
                hiscorepanel.onScreen = !hiscorepanel.onScreen;
            }
        }

        MenuItem {
            id: globalScoreItem
            height: Helper.mmToPixels(8)
            visible: PlatformID !== 8
            menuImage: "pics/globalscore.png"
            menuText: "Global Scores"
            menuColor: selectedItem == 3 ? "white" : foreground
            //            anchors.top: visible ? hiScoreItem.bottom : settingsItem.bottom
            //            anchors.left: parent.left
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            //            anchors.leftMargin: Sizer.largeFontSize() / 3

            onMenuItemClicked: {
                menupanel.onScreen = false;
                GameCircle.showLeaderBoard("galaxy_attack_hd_leaderboard_0");
            }
        }


        MenuItem {
            id: gameCircleItem
            height: Helper.mmToPixels(8)
            visible: PlatformID !== 8
            menuImage: "pics/agc_icon_RGB_full_clr.png"
            menuText: "Game Circle"
            menuColor: selectedItem == 4 ? "white" : foreground
            //            anchors.top: visible ? globalScoreItem.bottom : settingsItem.bottom
            //            anchors.left: parent.left
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            //            anchors.leftMargin: Sizer.largeFontSize() / 3

            onMenuItemClicked: {
                menupanel.onScreen = false;
                GameCircle.showGameCircle();
            }
        }

        MenuItem {
            id: exitItem
            height: Helper.mmToPixels(8);
            menuImage: "pics/x.svg"
            menuText: "Exit"
            menuColor: selectedItem == 5 ? "white" : foreground
            //            anchors.top: gameCircleItem.bottom
            //            anchors.left: parent.left
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            //            anchors.leftMargin: Sizer.largeFontSize() / 3

            onMenuItemClicked: {
                exitClicked();
            }
        }



        Text {
            id: text2
            color: selectedItem == 6 ? "white" : foreground
            text: "http://piggz.co.uk/?q=content/galaxy-attack-hd"
            //            anchors.top: exitItem.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            font.pixelSize: Sizer.smallFontSize()

            MouseArea {
                anchors.fill: parent;
                onClicked: Qt.openUrlExternally(text2.text);
            }
        }

        Text {
            id: textdonate
            color: selectedItem == 7 ? "white" : foreground
            text: "Donate"
            //            anchors.top: text2.bottom
            anchors.right: parent.right
            font.pixelSize: Sizer.largeFontSize()
            //            anchors.topMargin: Sizer.largeFontSize() / 3
            anchors.rightMargin: Sizer.largeFontSize() / 3
            visible: ANDROID_MARKET === "GOOGLE"
            MouseArea {
                anchors.fill: parent;
                onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVTJ5JNBQA72A");
            }
        }
    }

    function downPressed() {
        selectedItem++;
        if (selectedItem > maxItem) {
            selectedItem = 1;
        }
    }

    function upPressed() {
        selectedItem--;
        if (selectedItem < 1) {
            selectedItem = maxItem;
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
            gameCircleItem.click();
        }
        if (selectedItem == 5) {
            exitItem.click();
        }
        if (selectedItem == 6) {
            Qt.openUrlExternally(text2.text)
        }
        if (selectedItem == 7) {
            Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QVTJ5JNBQA72A");
        }
    }
}
