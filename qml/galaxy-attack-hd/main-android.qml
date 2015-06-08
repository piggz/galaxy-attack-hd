import QtSensors 5.0
import QtQuick 2.0
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
    focus: true

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
    property bool optFullGameBought: false

    property int axisModifier: optReverseAxis ? -1 : 1

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
        anchors.verticalCenter: spacelogo.verticalCenter
        anchors.horizontalCenter: invaderslogo.horizontalCenter
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

    PGZDialog {
        id:buyDialog
        z: 50
        anchors.centerIn: parent
        message: "You can unlock the full game with unlimited levels\nfor the equivalent of less than $1\nPress [Yes] to buy using Google Play\nor [No] to continue with the free version"
        onClickedNo: {
            buyDialog.onScreen = false
        }

        onClickedYes: {
            buyDialog.onScreen = false
            console.log("buying full game...");
            IAP.purchaseItem("full_game");
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

    ImageButton {
        id: infoImage
        image: "pics/info.png"
        width: Helper.mmToPixels(9);
        height: Helper.mmToPixels(9);
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        smooth: false
        
        onClicked: infoMessage.onScreen = true;

    }

    //Play button
    ImageButton {
        id: buttonPlay
        width: Helper.mmToPixels(9);
        height: Helper.mmToPixels(9);
        anchors.right: infoImage.left;
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        visible: gameState === "NOTRUNNING"

        image: ANDROID_MARKET === "AMAZON" ? "pics/amazon_store.png": "pics/play_store.png"

        onClicked: {
            if (ANDROID_MARKET === "AMAZON") {
                Qt.openUrlExternally("amzn://apps/android?s=uk.co.piggz&showAll=1");
            } else {
                Qt.openUrlExternally("market://search?q=pub:Adam Pigg");
            }
        }
    }

    ImageButton {
        id: iapButton
        image: "pics/buy_full_game.png"
        width: Helper.mmToPixels(9);
        height: Helper.mmToPixels(9);
        anchors.right: buttonPlay.left;
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        smooth: false
        visible: gameState == "NOTRUNNING" && !optFullGameBought && ANDROID_MARKET === "GOOGLE"

        onClicked: {
            buyDialog.onScreen = true;
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
        console.log("startup");
        loadSettings();
        Logic.cmdNotRunning();

        //Load sound effects
        NativeAudio.registerSound("assets:/qml/galaxy-attack-hd/sounds/shoot.wav.pcm", "shoot");
        NativeAudio.registerSound("assets:/qml/galaxy-attack-hd/sounds/explosion.wav.pcm", "explosion");
        NativeAudio.registerSound("assets:/qml/galaxy-attack-hd/sounds/invaderkilled.wav.pcm", "killed");
        NativeAudio.registerSound("assets:/qml/galaxy-attack-hd/sounds/ufo_lowpitch.wav.pcm", "mystery");

        if (IAP.checkItemPurchased("full_game") === 0 || ANDROID_MARKET === "AMAZON") {
            optFullGameBought = true;
        } else {
            optFullGameBought = false;
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
        if ((event.key === Qt.Key_Left) || (event.key === Qt.Key_Right)){
            Logic.scheduleDirection(0);
        }
    }

    Keys.onPressed: {
        if (PlatformID === 4 && event.key === Qt.Key_Back) {
            event.accepted = true;
            handleBack();
            return;
        }

        if (event.key === Qt.Key_P) {
            event.accepted = true;
            if (gameState === "RUNNING") {
                Logic.cmdPause();
            } else if (gameState === "PAUSED") {
                Logic.cmdResume();
            }
        } else if (event.key === Qt.Key_Q) {
            event.accepted = true;

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
        } else if (event.key === Qt.Key_Menu) {
            event.accepted = true;
            handleMenu();
        }
    }

    Connections {
        target: Viewer
        onWindowStateChanged: {
            console.log("Window state changed", windowState);
            if (windowState && 1) {
                if (gameState != "NOTRUNNING") {
                    Logic.cmdPause();
                }
            }
        }
        onVisibleChanged: {
            console.log("visible", visible);
        }

    }

    Connections {
        target: IAP
        onItemPurchased: {
            console.log("Item Name:", itemName, " Purchase State: ", purchaseState);

            if (itemName === "full_game" && purchaseState === 0) {
                powerMessage.displayMessage("Thank you, game unlocked!");
                optFullGameBought = true;
            } else {
                powerMessage.displayMessage("Buying game failed");
                optFullGameBought = false;
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
        GameCircle.submitScore("galaxy_attack_hd_leaderboard_0", ScoreModel.bestScore());
    }

    function loadSettings(){
        optUseOSC = Helper.getBoolSetting("bUseOSC", false);
        optLeftHandedOSC = Helper.getBoolSetting("bLeftHandOSC", false);
        optAlternateAxis = Helper.getBoolSetting("bAlternateAxis", false);
        optReverseAxis = Helper.getBoolSetting("bReverseAxis", ANDROID_MARKET === "GOOGLE" ? false : true); //true for kindle, false otherwise
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
