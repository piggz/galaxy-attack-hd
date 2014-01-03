//import QtMobility.sensors 1.2
import QtSensors 5.0
import QtQuick 2.0
import SpaceInvaders 1.0

import "sizer.js" as Sizer;
import "logic.js" as Logic

Rectangle {
    id: board
    objectName: "gameBoard"
    color: "#000000"
    width: 854
    height:  480
    focus: true

    property string gameState
    property string lastGameState;

    //Settings============================================

    property bool optFlashOnFire: true
    property bool optSFX: true
    property bool optUseOSC: false
    property bool optLeftHandedOSC: false
    property bool optAlternateAxis: false
    property bool optReverseAxis: false

    property int axisModifier: optReverseAxis ? -1 : 1

    ColorAnimation on color {id:flashanim; from: "#999999"; to: "black"; duration: 200 }

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
            if (!optUseOSC || gameState !== "RUNNING") {
                Logic.screenTap();
            }
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

    Text {
        id: gptext
        text: "Gamepad detected so using it"
        color: "#ffffff"
        visible: GamepadController.numDevices > 0 && gameState == "NOTRUNNING";
        anchors.horizontalCenter: board.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.verticalCenterOffset: 50
    }


    Ship {
        id:ship
        x: (board.width - ship.width) / 2;
        y: board.height - (ship.height * 2) - 3;
    }

    Timer {
        id: heartbeat;
        interval: 32
        running: true;
        repeat: true;
        onTriggered: {
            gamepad.poll();
            Logic.mainEvent();
        }
    }

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

    Timer {
        id: scoreloopTimer
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            ScoreLoop.processEvents();
        }
    }

    CloseButton {
        id: closeButton

        onClicked: {
            console.log("exit pressed");
            exitPressed();
        }
    }

    Image {
        id: menubutton

        source: "pics/menu.png"
        width: Helper.mmToPixels(7);
        height: Helper.mmToPixels(7);
        anchors.right: closeButton.left
        anchors.rightMargin: closeButton.width
        anchors.top: parent.top
        anchors.topMargin: 0
        fillMode: Image.PreserveAspectFit
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
        color: "#00ff00"

    }

    Rectangle {
        id: topline
        width: parent.width
        height:  1
        x: 0
        anchors.top: closeButton.bottom
        color: "#00ff00"
    }

    Accelerometer  {
        id: accelerometer
        Component.onCompleted: start()
        onReadingChanged: {
            if (!optUseOSC && GamepadController.numDevices == 0) {
                var r = reading
                if (optAlternateAxis) {
                    Logic.scheduleDirection((r.x) * (5 * axisModifier))
                } else {
                    Logic.scheduleDirection((r.y) * (5 * axisModifier))
                }
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
        visible: optUseOSC && !gamepad.gpEnabled;

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

    GamePad {
        id: gamepad
        gpUseInternalTimer: false

        onLeftChanged: {
            if (pressed) {
                Logic.scheduleDirection(-10);
            }
        }
        onRightChanged: {
            if (pressed) {
                Logic.scheduleDirection(10);
            }
        }

        onUpChanged: {
            if (pressed) {
                handleUp();
            }
        }

        onDownChanged: {
            if (pressed) {
                handleDown()
            }
        }

        onNoDirection: {
            Logic.scheduleDirection(0);
        }
        onFireChanged: {
            if (pressed) {
                handleFire();
            }
        }
        onMenuChanged: {
            if (pressed) {
                handleMenu();
            }
        }

    }

    SettingsAndroid {
        id:settingspanel;
        z: 10
        onScreen: false
    }

    HiScores {
        id:hiscorepanel;
        z: 9
        onScreen: false

        onExitClicked: {
            onScreen = false;
        }
    }

    ScoreLoopBoard {
        id:scoreloopBoard
        z:8
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

    Explosion {
        id: explosion
        x: 0
        y: 0
    }

    SpaceLogo {
        id: spacelogo
        anchors.verticalCenter: board.verticalCenter
        anchors.verticalCenterOffset: -75
        anchors.horizontalCenter: board.horizontalCenter
        anchors.horizontalCenterOffset: -100
    }

    InvadersLogo {
        id: invaderslogo
        anchors.verticalCenter: board.verticalCenter
        anchors.verticalCenterOffset: 75
        anchors.horizontalCenter: board.horizontalCenter
        anchors.horizontalCenterOffset: 100
    }

    SequentialAnimation {
        id: startAnimation
        running: false
        PropertyAnimation { target: spacelogo; property: "state"; from: "HIDDEN"; to: "VISIBLE" }
        PauseAnimation { duration: 1000 }
        PropertyAnimation { target: invaderslogo;property: "state";  from: "HIDDEN"; to: "VISIBLE" }

    }

    ExitDialog {
        id:exitDialog
        z: 50
        anchors.centerIn: parent
        onClickedNo: {
            exitDialog.onScreen = false;
        }

        onClickedYes: {
            exitDialog.onScreen = false;
            exitGame();
        }
    }

    Image {
        id: infoImage
        source: "pics/info.png"
        width: Helper.mmToPixels(10);
        height: Helper.mmToPixels(10);
        anchors.left: parent.left
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

    //=====================Functions=========================

    function startupFunction() {
        console.log("startup");
        loadSettings();
        Logic.cmdNotRunning();

        if (PlatformID === 4 || PlatformID === 6 || PlatformID === 7) { //ANDROID/PLAYBOOK/BB10
            //Load sound effects
            NativeAudio.registerSound("assets:/qml/pgz-spaceinvaders/sounds/shoot.wav.pcm", "shoot");
            NativeAudio.registerSound("assets:/qml/pgz-spaceinvaders/sounds/explosion.wav.pcm", "explosion");
            NativeAudio.registerSound("assets:/qml/pgz-spaceinvaders/sounds/invaderkilled.wav.pcm", "killed");
            NativeAudio.registerSound("assets:/qml/pgz-spaceinvaders/sounds/ufo_lowpitch.wav.pcm", "mystery");

        }
        console.log("startup done");
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

    Component.onCompleted: startupFunction();

    Keys.onEscapePressed:exitGame();

    Keys.onReleased: {
        console.log(event.key);
    }

    Keys.onPressed: {
        console.log(event.key);
        if (PlatformID === 4 && event.key === Qt.Key_Back) {
            event.accepted = true;
            handleBack();
            return;
        }

        if (event.key == Qt.Key_P) {
            event.accepted = true;
            if (gameState == "RUNNING") {
                Logic.cmdPause();
            } else if (gameState == "PAUSED") {
                Logic.cmdResume();
            }
        } else if (event.key == Qt.Key_Q) {
            event.accepted = true;

            if (gameState != "NOTRUNNING") {
                Logic.cmdDead();
            }
        }
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
        if (scoreloopBoard.onScreen) {
            scoreloopBoard.onScreen = false;
            return;
        }
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

}
