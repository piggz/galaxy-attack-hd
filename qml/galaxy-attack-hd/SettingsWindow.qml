import QtQuick 2.0
import "sizer.js" as Sizer;

Rectangle {
    id: settingspanel

    property bool onScreen: false
    property int selectedItem: 0
    property bool animating: !(x == (board.width - width - 5) || ( x  == (board.width + 5)))
    property color foreground: "#7DF9FF"


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

    Column {
        anchors.fill: parent
        anchors.margins: Sizer.largeFontSize() / 3
        spacing: Sizer.largeFontSize() / 3

        InvaderOption {
            id: flashOption
            optionText: "Flash on Fire"
            optionColor: selectedItem == 1 ? "white" : foreground
            height: Sizer.largeFontSize() + 10
            width: parent.width / 2
            optionTextSize: Sizer.largeFontSize()

            onOptionClicked: {
                optFlashOnFire = val;
            }
        }

        InvaderOption {
            id: sfxOption
            optionText: "Sound Effects"
            optionColor: selectedItem == 2 ? "white" : foreground
            height: Sizer.largeFontSize() + 10
            width: parent.width / 2
            optionTextSize: Sizer.largeFontSize()

            onOptionClicked: {
                optSFX = val;
            }

        }

        InvaderOption {
            id: oscOption
            optionText: "On-Screen Control"
            optionColor: selectedItem == 3 ? "white" : foreground
            height: Sizer.largeFontSize() + 10
            width: parent.width / 2
            optionTextSize: Sizer.largeFontSize()

            onOptionClicked: {
                optUseOSC = val;
            }

        }

        InvaderOption {
            id: lhOption
            optionText: "Left Hand OSC"
            optionColor: selectedItem == 4 ? "white" : foreground
            height: Sizer.largeFontSize() + 10
            width: parent.width / 2
            optionTextSize: Sizer.largeFontSize()

            onOptionClicked: {
                optLeftHandedOSC = val;
            }

        }
    }
    
    function startupFunction() {
        flashOption.state = optFlashOnFire? "TRUE" : "FALSE";
        sfxOption.state = optSFX? "TRUE" : "FALSE";
        oscOption.state = optUseOSC ? "TRUE" : "FALSE";
        lhOption.state = optLeftHandedOSC ? "TRUE" : "FALSE";
    }

    Component.onCompleted: startupFunction();

    function downPressed() {
        selectedItem++;
        if (selectedItem > 4) {
            selectedItem = 1;
        }
    }

    function upPressed() {
        selectedItem--;
        if (selectedItem < 1) {
            selectedItem = 4;
        }
    }

    function firePressed() {
        if (selectedItem == 1) {
            flashOption.click();
        }
        if (selectedItem == 2) {
            sfxOption.click();
        }
        if (selectedItem == 3) {
            oscOption.click();
        }
        if (selectedItem == 3) {
            lhOption.click();
        }

    }
}
