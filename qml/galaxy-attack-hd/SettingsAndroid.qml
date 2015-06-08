import QtQuick 2.0
import "sizer.js" as Sizer;

Rectangle {
    id: settingspanel

    property bool onScreen: false
    property int selectedItem: 0
    property bool animating: !(x == (board.width - width - 5) || ( x  == (board.width + 5)))
    property color foreground: "#7DF9FF"
    property int optionCount: 6

    height: board.height - 30
    width:  board.width/1.3

    border.color: foreground
    border.width: 5
    color:  "black"
    radius: 10

    y: 15
    x: onScreen?(board.width - width - 5):(board.width + 5)

    Behavior on x {
        NumberAnimation {duration: 400}
    }

    //Dummy mouse area to stop events being passed through
    MouseArea {
        anchors.fill: parent
    }

    InvaderOption {
        id: oscOption
        optionText: "Use On-Screen Control"
        optionColor: selectedItem == 1 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: parent.top;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optUseOSC = val;
        }
    }

    InvaderOption {
        id: leftHandOSC
        optionText: "Left Hand OSC"
        optionColor: selectedItem == 2 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: oscOption.bottom;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optLeftHandedOSC = val;
        }
    }

    InvaderOption {
        id: altAxisOption
        optionText: "Alternate Axis"
        optionColor: selectedItem == 3 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: leftHandOSC.bottom;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optAlternateAxis = val;
        }
    }

    InvaderOption {
        id: reverseAxisOption
        optionText: "Reverse Axis"
        optionColor: selectedItem == 4 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: altAxisOption.bottom;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optReverseAxis = val;
        }
    }

    InvaderOption {
        id: flashOption
        optionText: "Flash on Fire"
        optionColor: selectedItem == 5 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: reverseAxisOption.bottom;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optFlashOnFire = val;
        }
    }

    InvaderOption {
        id: sfxOption
        optionText: "Sound Effects"
        optionColor: selectedItem == 6 ? "white" : foreground
        height: 40
        width: parent.width / 2
        anchors.top: flashOption.bottom;
        anchors.topMargin: Sizer.largeFontSize() / 3
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optSFX = val;
        }
    }

    function startupFunction() {
        oscOption.state = optUseOSC ? "TRUE" : "FALSE";
        leftHandOSC.state = optLeftHandedOSC ? "TRUE" : "FALSE";
        flashOption.state = optFlashOnFire ? "TRUE" : "FALSE";
        sfxOption.state = optSFX ? "TRUE" : "FALSE";
        altAxisOption.state = optAlternateAxis ? "TRUE" : "FALSE";
        reverseAxisOption.state = optReverseAxis ? "TRUE" : "FALSE";
        //gamernameoption.text = gamerName;
        //passwordoption.text = password;
    }

    Component.onCompleted: startupFunction();

    function downPressed() {
        selectedItem++;
        if (selectedItem > optionCount) {
            selectedItem = 1;
        }
    }

    function upPressed() {
        selectedItem--;
        if (selectedItem < 1) {
            selectedItem = optionCount;
        }
    }

    function firePressed() {
        if (selectedItem == 1) {
            oscOption.click();
        }
        if (selectedItem == 2) {
            leftHandOSC.click();
        }
        if (selectedItem == 3) {
            altAxisOption.click();
        }
        if (selectedItem == 4) {
            reverseAxisOption.click();
        }
        if (selectedItem == 5) {
            flashOption.click();
        }
        if (selectedItem == 6) {
            sfxOption.click();
        }

    }
}
