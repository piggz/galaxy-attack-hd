import QtSensors 5.0
import QtQuick 2.0
import harbour.pgz.galaxy.attack.hd 1.0

import "sizer.js" as Sizer;
import "logic.js" as Logic

Rectangle {
    id: board
    objectName: "gameBoard"
    color: "#000000"
    width: 854
    height:  480

    property string gameState
    property string lastGameState;
    property int selectedItem: 0
    property int numItems: 2

    //Settings============================================

    property bool optFlashOnFire: true
    property bool optSFX: true
    property bool optUseOSC: false
    property bool optLeftHandedOSC: false

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
        font.pixelSize: menuButton.height - 10;
    }

    Text {
        id: leveltext
        text: "Level: 0"
        color: "#ffffff"
        y: 2
        anchors.horizontalCenter: board.horizontalCenter
        font.pixelSize: menuButton.height - 10;
    }


    Text {
        id: starttext
        text: gameState === "NOTRUNNING" ? "Tap the green button to start!" : "Tap the screen or fire to continue"
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
        running: PlatformID === 7 || PlatformID === 6
        onTriggered: {
            if (PlatformID === 7 || PlatformID === 6 ){
                ScoreLoop.processEvents();
            }
        }
    }

    /*
    CloseButton {
        id: closeButton

        onClicked: {
            console.log("exit pressed");
            exitPressed();
        }
    }*/

    Image {
        id: menuButton

        source: "pics/menu.svg"
        width: Helper.mmToPixels(5);
        height: Helper.mmToPixels(5);
        anchors.right: parent.right
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
        anchors.right: menuButton.left
        onScreen: false
        z:15

        onExitClicked: {
            menupanel.onScreen = false;
            exitDialog.onScreen = true;
        }
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
        anchors.top: menuButton.bottom
        color: "#7DF9FF"
    }

    Accelerometer  {
        id: accelerometer
        Component.onCompleted: start()
        onReadingChanged: {
            if (!optUseOSC && GamepadController.numDevices == 0) {
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
                handleLeft();
                //Logic.scheduleDirection(-10);
            }
        }
        onRightChanged: {
            if (pressed) {
                handleRight();
                //Logic.scheduleDirection(10);
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

    SettingsWindow {
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


    ExitDialog {
        id:exitDialog
        z: 50
        anchors.centerIn: parent
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
        width: Helper.mmToPixels(6);
        height: Helper.mmToPixels(6);
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        highlighed: selectedItem === 1;

        onClicked: Logic.cmdNewGame()
    }

    ImageButton {
        id: infoImage
        image: "pics/info.png"
        width: Helper.mmToPixels(6);
        height: Helper.mmToPixels(6);
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        highlighed: selectedItem === 2

        onClicked: infoMessage.onScreen = true
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
            NativeAudio.registerSound("qml/galaxy-attack-hd/sounds/shoot.wav", "shoot");
            NativeAudio.registerSound("qml/galaxy-attack-hd/sounds/explosion.wav", "explosion");
            NativeAudio.registerSound("qml/galaxy-attack-hd/sounds/invaderkilled.wav", "killed");
            NativeAudio.registerSound("qml/galaxy-attack-hd/sounds/ufo_lowpitch.wav", "mystery");

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

        if (event.key == Qt.Key_P) {
            if (gameState == "RUNNING") {
                Logic.cmdPause();
            } else if (gameState == "PAUSED") {
                Logic.cmdResume();
            }
        } else if (event.key == Qt.Key_Q) {
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
        optFlashOnFire = Helper.getBoolSetting("bFlashOnFire", true);
        optSFX = Helper.getBoolSetting("bSFX", true);
    }

    function saveSettings() {
        console.log("Saving Settings");

        Helper.setSetting("bFlashOnFire", optFlashOnFire);
        Helper.setSetting("bSFX", optSFX);
        Helper.setSetting("bUseOSC", optUseOSC);
        Helper.setSetting("bLeftHandOSC", optLeftHandedOSC);

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

    function handleLeft() {
        if (gameState === "RUNNING") {
            Logic.scheduleDirection(-10);
            return;
        }

        if (exitDialog.onScreen) {
            exitDialog.leftPressed();
            return;
        }

        if (gameState === "NOTRUNNING") { //On main screen
            selectedItem--;
            if (selectedItem <= 0) {
                selectedItem = numItems;
            }

        }
    }

    function handleRight() {
        if (gameState === "RUNNING") {
            Logic.scheduleDirection(10);
            return;
        }

        if (exitDialog.onScreen) {
            exitDialog.rightPressed();
            return;
        }

        if (gameState === "NOTRUNNING") { //On main screen
            selectedItem++;
            if (selectedItem > numItems) {
                selectedItem = 1;
            }
        }

    }

    function handleFire() {
        if (settingspanel.onScreen) {
            settingspanel.firePressed();
        } else if (menupanel.onScreen) {
            menupanel.firePressed();
        } else if (infoMessage.onScreen) {
            infoMessage.onScreen = false;
        } else if (exitDialog.onScreen) {
            exitDialog.firePressed();
        } else {
            if (gameState === "NOTRUNNING") { //On main screen
                if (selectedItem === 1 || selectedItem === 0) {
                    startImage.clicked();
                } else if (selectedItem === 2) {
                    infoImage.clicked();
                }
            } else {
                Logic.screenTap();
            }
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

}
