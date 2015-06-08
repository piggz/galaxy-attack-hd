//import QtMobility.sensors 1.2
import QtSensors 5.0
import QtQuick 2.0
import QtMultimedia 5.0
import SpaceInvaders 1.0
import QtQuick.Particles 2.0

import "sizer.js" as Sizer;
import "logic.js" as Logic


Rectangle {
    id: board
    objectName: "gameBoard"
    color: "#000000"
    width: 854
    height:  480
    //rotation: 90
    //transformOrigin: Item.TopLeft

    property alias particleSystem: particleSystem
    property string gameState
    property string lastGameState;

    //Settings============================================

    property bool optFlashOnFire: true
    property bool optSFX: true
    property bool optUseOSC: false
    property bool optLeftHandedOSC: false
    property bool optAlternateAxis: false
    property bool optReverseAxis: false

    ColorAnimation on color {id:flashanim; from: "#999999"; to: "black"; duration: 200 }

    Image {
        id: background
        source: "pics/background.png"
        anchors.fill: parent
    }

    MouseArea {
        id: themousearea
        x: 0
        y: 30

        drag.minimumY: -1000
        drag.minimumX: -1000
        drag.maximumY: 1000
        drag.maximumX: 1000
        anchors.rightMargin: 0
        anchors.bottomMargin: 1
        anchors.leftMargin: 0
        anchors.topMargin: 30
        anchors.fill: board
        onPressed: {
            Logic.screenTap();
        }
    }

    Text {
        id: scoretext
        text: "Score: 0"
        color: "#ffffff"
        x: 2
        y: 2
        font.pixelSize: closeButton.height - 10;
    }

    Text {
        id: leveltext
        text: "Level: 0"
        color: "#ffffff"
        y: 2
        anchors.horizontalCenter: board.horizontalCenter
        font.pixelSize: closeButton.height - 10;
    }

    Text {
        id: starttext
        text: "Tap screen to start"
        color: "#ffffff"
        anchors.horizontalCenter: board.horizontalCenter
        anchors.top: topline.bottom
        anchors.verticalCenterOffset: 50
    }

    Ship {
        id:ship
        x: (board.width - ship.width) / 2;
        y: board.height - (ship.height * 2) - 3;
    }
    /*
    SoundEffect {
        id: shootSound
        source: "sounds/shoot.wav"
    }

    SoundEffect {
        id: destroyAlienSound
        source: "sounds/invaderkilled.wav"
    }

    SoundEffect {
        id: destroyShipSound
        source: "sounds/explosion.wav"
    }

    SoundEffect {
        id: mysteryShipSound
        source: "sounds/ufo_lowpitch.wav"
        loops: SoundEffect.Infinite
    }
*/
    Timer {
        id: starttimer
        repeat:  false
        interval: 1000
        running: true
        onTriggered: {
            startAnimation.start();
        }
    }

    Timer {
        id: heartbeat;
        interval: 32
        running: false;
        repeat: true;
        onTriggered: Logic.mainEvent();
    }

    Timer {
        id: alienanimation
        interval:  600
        running: false
        repeat: true
        onTriggered: Logic.moveAliens()
    }

    Timer  {
        id: deadtimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            Logic.cmdNotRunning();
        }
    }

    CloseButton {
        id: closeButton
        z: 8

        onClicked: {
            console.log("exit pressed");
            exitPressed();
        }
    }

    Image {
        id: menubutton

        source: "pics/menu.svg"
        width: closeButton.width;
        height: closeButton.height;
        anchors.right: closeButton .left
        anchors.rightMargin: closeButton.width
        anchors.top: parent.top
        anchors.topMargin: 0
        fillMode: Image.Stretch
        smooth: false

        MouseArea {
            id: menuarea
            anchors.fill: parent
            onPressed: {
                menupanel.onScreen = !menupanel.onScreen;
                if (menupanel.onScreen && gameState == "RUNNING") {
                    Logic.cmdPause();
                }
            }
        }
    }

    Menu {
        id:menupanel
        anchors.right: menubutton.left
        onScreen: false
        z:15
    }

    Rectangle {
        id: invadeline
        width: parent.width
        height:  1
        x: 0
        y: parent.height - ship.height
        color: "#7DF9FF"

    }

    Rectangle {
        id: topline
        width: parent.width
        height:  1
        x: 0
        anchors.top: closeButton.bottom
        color: "#7DF9FF"
    }

    Accelerometer  {
        id: accelerometer
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            if (PlatformID === 4)
                Logic.scheduleDirection((r.y) * -5); //Android
            else if (PlatformID === 0 || PlatformID === 2 || PlatformID === 3 ||  PlatformID === 7) {
                Logic.scheduleDirection((r.y) * 5); //Symbian/Harmatten/Meego/BB10
            } else if (PlatformID === 1 || PlatformID === 6) {
                Logic.scheduleDirection((r.x) * -5); //Maemo / Playbook
            }
        }
    }

    OnScreenControl {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        anchors.leftMargin: 20
        anchors.rightMargin: 20

        height: parent.height / 6

        leftHanded: optLeftHandedOSC

        opacity: 0.4

        z:1
        visible: optUseOSC;

        onMoveLeft: {
            Logic.scheduleDirection(-10);
        }
        onMoveRight: {
            Logic.scheduleDirection(10);
        }
        onMoveStop: {
            Logic.scheduleDirection(0);
        }
        onFire: {
            Logic.screenTap();
        }
    }


    SettingsAndroid {
        id:settingspanel;
        z: 10
        onScreen: false
    }

    HiScores {
        id:hiscorepanel;
        z: 10
        onScreen: false

        onExitClicked: {
            onScreen = false;
        }
    }

    Bunker {
        id: bunker1
        x: Sizer.bunkerX(1);
        y: Sizer.bunkerY()
        width: Sizer.bunkerWidth()
        height: Sizer.bunkerHeight()
    }
    Bunker {
        id: bunker2
        x: Sizer.bunkerX(2);
        y: Sizer.bunkerY()
        width: Sizer.bunkerWidth()
        height: Sizer.bunkerHeight()
    }
    Bunker {
        id: bunker3
        x: Sizer.bunkerX(3);
        y: Sizer.bunkerY()
        width: Sizer.bunkerWidth()
        height: Sizer.bunkerHeight()
    }
    Bunker {
        id: bunker4
        x: Sizer.bunkerX(4);
        y: Sizer.bunkerY()
        width: Sizer.bunkerWidth()
        height: Sizer.bunkerHeight()
    }

    SpaceLogo {
        id: spacelogo
        y: board.height / 2 - 30 - height
        offScreenLocation: -width - 10
        onScreenLocation: board.width / 2 - width + 50
    }

    InvadersLogo {
        id: invaderslogo
        y: board.height / 2 + 30
        offScreenLocation: board.width + 10
        onScreenLocation: board.width / 2 - 50
    }


    Hd {
        id: hdlogo
        anchors.verticalCenter: board.verticalCenter
        anchors.verticalCenterOffset: -50
        anchors.right: invaderslogo.right
    }

    SequentialAnimation {
        id: startAnimation
        running: false
        PropertyAnimation { target: spacelogo; property: "state"; from: "HIDDEN"; to: "VISIBLE" }
        PauseAnimation { duration: 1000 }
        PropertyAnimation { target: invaderslogo;property: "state";  from: "HIDDEN"; to: "VISIBLE" }
        PauseAnimation { duration: 1000 }
        PropertyAnimation { target: hdlogo ;property: "state";  from: "HIDDEN"; to: "VISIBLE" }
    }

    PGZDialog {
        id:exitDialog
        z: 50
        anchors.centerIn: parent
        message: "Are you sure you want to exit?"
        onClickedNo: {
            exitDialog.onScreen = false
        }

        onClickedYes: {
            exitDialog.onScreen = false
            exitGame();
        }
    }

    ImageButton {
        id: startImage
        image: "pics/start.png"
        width: Helper.mmToPixels(9);
        height: Helper.mmToPixels(9);
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter

        onClicked: Logic.cmdNewGame()
    }

    Image {
        id: infoImage
        source: "pics/info.png"
        width: 64
        height: 64
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        smooth: false

        MouseArea {
            anchors.fill: parent
            onClicked: infoMessage.onScreen = true;
        }
    }

    InfoMessage {
        id: infoMessage
        anchors.centerIn: parent
        onClickedClose: {
            infoMessage.onScreen = false;
        }
    }

    PowerMessage {
        id: powerMessage
    }

    ParticleSystem {
        id: particleSystem;
        anchors.fill: parent
        z: 5
        ImageParticle {
            groups: ["red"]
            system: particleSystem
            color: Qt.darker("red");//Actually want desaturated...
            source: "pics/particle-brick.png"
            colorVariation: 0.4
            alpha: 0.1
        }
        ImageParticle {
            groups: ["blue"]
            system: particleSystem
            color: Qt.darker("blue");//Actually want desaturated...
            source: "pics/particle-brick.png"
            colorVariation: 0.4
            alpha: 0.1
        }
        ImageParticle {
            groups: ["purple"]
            system: particleSystem
            color: Qt.darker("#ff00ff");//Actually want desaturated...
            source: "pics/particle-brick.png"
            colorVariation: 0.4
            alpha: 0.1
        }
    }

    //=====================Functions=========================

    function startupFunction() {
        loadSettings();
        Logic.cmdNotRunning();

        if (PlatformID === 4 || PlatformID === 6 || PlatformID === 7) { //ANDROID/PLAYBOOK/BB10
            //Load sound effects
            NativeAudio.registerSound("qml/pgz-spaceinvaders/sounds/shoot.wav", "shoot");
            NativeAudio.registerSound("qml/pgz-spaceinvaders/sounds/explosion.wav", "explosion");
            NativeAudio.registerSound("qml/pgz-spaceinvaders/sounds/invaderkilled.wav", "killed");
            NativeAudio.registerSound("qml/pgz-spaceinvaders/sounds/ufo_lowpitch.wav", "mystery");

        }
    }

    function exitPressed(){
        if (gameState != "NOTRUNNING") {
            Logic.cmdPause();
        }
        exitDialog.onScreen = true;
    }

    function exitGame(){
        saveSettings()
        Qt.quit();
    }


    focus: true

    Component.onCompleted: startupFunction();

    Keys.onEscapePressed:exitGame();

    Keys.onPressed: {
        //Android menu button
        if (PlatformID === 4 && event.key === 16777301) {
            if (menupanel.state == "HIDDEN") {
                menupanel.state = "VISIBLE";
                if (gameState == "RUNNING") {
                    Logic.cmdPause();
                }

            } else {
                menupanel.state = "HIDDEN";
            }
            return;
        }

        if (event.key === Qt.Key_P) {
            if (gameState === "RUNNING") {
                Logic.cmdPause();
            } else if (gameState === "PAUSED") {
                Logic.cmdResume();
            }
        } else if (event.key === Qt.Key_Q) {
            if (gameState != "NOTRUNNING") {
                Logic.cmdDead();
            }
        } else if (event.key === Qt.Key_Left) {
            event.accepted = true;
            handleLeft();
        } else if (event.key === Qt.Key_Right) {
            event.accepted = true;
            handleRight();
        } else if (event.key === Qt.Key_Up) {
            event.accepted = true;
            handleUp();
        } else if (event.key === Qt.Key_Down) {
            event.accepted = true;
            handleDown();
        } else if (event.key === Qt.Key_Enter) {
            event.accepted = true;
            handleFire();
        } else if ((event.key === Qt.Key_Menu) || (event.key === Qt.Key_M)) {
            event.accepted = true;
            handleMenu();
        } else if (event.key === Qt.Key_Space) {
            Logic.screenTap();
        }
    }

    Keys.onReleased: {
        Logic.scheduleDirection(0);
    }

    Connections {
        target: Viewer
        onWindowStateChanged: {
            if (windowState && 1) {
                if (gameState != "NOTRUNNING") {
                    Logic.cmdPause();
                }
            }
        }
    }


    function nowString()
    {
        var d = new Date();
        var curr_date = d.getDate();
        var curr_month = d.getMonth() + 1;
        var curr_year = d.getFullYear();
        return curr_year + "-" + curr_month + "-" + curr_date;
    }

    function addNewScore(level, score) {
        ScoreModel.addScore(score, "default", "Galaxy Attack HD", 1, level, nowString());
    }

    function loadSettings(){
        optUseOSC = Helper.getBoolSetting("bUseOSC", false);
        optLeftHandedOSC = Helper.getBoolSetting("bLeftHandOSC", false);
        optAlternateAxis = Helper.getBoolSetting("bAlternateAxis", false);
        optReverseAxis = Helper.getBoolSetting("bReverseAxis", true); //true for kindle, false otherwise
        optFlashOnFire = Helper.getBoolSetting("bFlashOnFire", true);
        optSFX = Helper.getBoolSetting("bSFX", true);
    }

    function saveSettings() {
        console.log("Saving Settings");

        Helper.setSetting("bFlashOnFire", optFlashOnFire);
        Helper.setSetting("bSFX", optSFX);
        Helper.setSetting("bUseOSC", optUseOSC);
        Helper.setSetting("bLeftHandOSC", optLeftHandedOSC);
        Helper.setSetting("bAlternateAxis", optAlternateAxis);
        Helper.setSetting("bReverseAxis", optReverseAxis);

        ScoreModel.saveScores();

        console.log("Saved Settings");
    }


    function handleUp() {
        if (gameState !== "RUNNING") {

            if (settingspanel.onScreen) {
                settingspanel.upPressed();
                return;
            }

            if (menupanel.onScreen) {
                menupanel.upPressed();
                return;
            }
        }
    }

    function handleDown() {
        if (gameState !== "RUNNING") {
            if (settingspanel.onScreen) {
                settingspanel.downPressed();
                return;
            }

            if (menupanel.onScreen) {
                menupanel.downPressed();
                return;
            }
        }
    }

    function handleFire() {
        if (settingspanel.onScreen) {
            settingspanel.firePressed();
        } else if (menupanel.onScreen) {
            menupanel.firePressed();
        } else if (exitDialog.onScreen){
            exitDialog.firePressed();
        } else {
            Logic.screenTap();
        }
    }

    function handleMenu() {
        console.log(settingspanel.onScreen, settingspanel.animating);

        if (settingspanel.onScreen) {
            if (!settingspanel.animating) {
                settingspanel.onScreen = false;
            }
            return;
        }

        if (!menupanel.animating) {
            menupanel.onScreen = !menupanel.onScreen;
            if (menupanel.onScreen && gameState == "RUNNING") {
                Logic.cmdPause();
            }
        }
    }

    function handleBack() {
        if (hiscorepanel.onScreen) {
            hiscorepanel.onScreen = false;
            return;
        }
        if (settingspanel.onScreen) {
            settingspanel.onScreen = false;
            return;
        }
        if (menupanel.onScreen) {
            menupanel.onScreen = false;
            return;
        }

        if (infoMessage.onScreen) {
            infoMessage.onScreen = false;
            return;
        }

        exitPressed();
    }

    function handleLeft() {
        if (exitDialog.onScreen) {
            exitDialog.leftPressed();
            return;
        }
        Logic.scheduleDirection(-10);
    }

    function handleRight() {
        if (exitDialog.onScreen) {
            exitDialog.rightPressed();
            return;
        }
        Logic.scheduleDirection(10);
    }

}
