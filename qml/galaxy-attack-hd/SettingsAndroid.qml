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

    InvaderOption {
        id: oscOption
        optionText: "Use On-Screen Control"
        height: 40
        width: parent.width / 2
        anchors.top: parent.top;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optUseOSC = val;
        }
    }

    InvaderOption {
        id: leftHandOSC
        optionText: "Left Hand OSC"
        height: 40
        width: parent.width / 2
        anchors.top: oscOption.bottom;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optLeftHandedOSC = val;
        }
    }

    InvaderOption {
        id: altAxisOption
        optionText: "Alternate Axis"
        height: 40
        width: parent.width / 2
        anchors.top: leftHandOSC.bottom;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optAlternateAxis = val;
        }
    }

    InvaderOption {
        id: reverseAxisOption
        optionText: "Reverse Axis"
        height: 40
        width: parent.width / 2
        anchors.top: altAxisOption.bottom;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optReverseAxis = val;
        }
    }

    InvaderOption {
        id: flashOption
        optionText: "Flash on Fire"
        height: 40
        width: parent.width / 2
        anchors.top: reverseAxisOption.bottom;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optFlashOnFire = val;
        }
    }

    InvaderOption {
        id: sfxOption
        optionText: "Sound Effects"
        height: 40
        width: parent.width / 2
        anchors.top: flashOption.bottom;
        anchors.topMargin: 20
        optionTextSize: Sizer.largeFontSize()

        onOptionClicked: {
            optSFX = val;
        }
    }

    /*
    //Gamer Name
    Rectangle {
        id:gamernameborder
        height: Sizer.largeFontSize() + 8
        width: 160
        x: 20
        color: "#000000"
        border.color: "#00ff00"
        border.width: 3
        anchors.top: sfxOption.bottom;
        anchors.topMargin: 20;

        TextInput {
            id: gamernameoption
            anchors.fill: parent
            font.pixelSize: Sizer.largeFontSize()
            color: "#00ff00"
            onFocusChanged: {
                if (focus) {
                    gamernameborder.border.color = "#ff0000"
                } else {
                    gamernameborder.border.color = "#00ff00"

                }
            }
        }
    }

    Text {
        id: gamernametext
        text: "Gamer Name"
        font.pixelSize: Sizer.largeFontSize()
        color: "#00ff00"
        anchors.left: gamernameborder.right
        anchors.leftMargin: 20
        anchors.top: gamernameborder.top
    }

    //Password
    Rectangle {
        id:passwordborder
        height: Sizer.largeFontSize() + 8
        width: 160
        x: 20
        color: "#000000"
        border.color: "#00ff00"
        border.width: 3
        anchors.top: gamernameborder.bottom;
        anchors.topMargin: 20;

        TextInput {
            id: passwordoption
            anchors.fill: parent
            font.pixelSize: Sizer.largeFontSize()
            color: "#00ff00"
            onFocusChanged: {
                if (focus) {
                    passwordborder.border.color = "#ff0000"
                } else {
                    passwordborder.border.color = "#00ff00"

                }
            }
        }
    }

    Text {
        id: passwordtext
        text: "Password"
        font.pixelSize: Sizer.largeFontSize()
        color: "#00ff00"
        anchors.left: passwordborder.right
        anchors.leftMargin: 20
        anchors.top: passwordborder.top
    }

    Rectangle {
        id: createaccount
        height: Sizer.largeFontSize() + 10
        width: createaccounttext.width + 10
        color: "#00ff00"
        border.width: 1
        anchors.top: passwordborder.bottom;
        anchors.topMargin: 10;
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: createaccounttext
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "Create Account"
            font.pixelSize: Sizer.largeFontSize()
            color: "#000000"
        }

        MouseArea  {
            anchors.fill: parent
            onClicked: {
                settingspanel.state = "HIDDEN";

                gamerName = gamernameoption.text;
                password = passwordoption.text;

                if (gamerName == "") {
                    powerMessage.displayMessage("Enter name");
                    return;
                }
                if (password == "") {
                    powerMessage.displayMessage("Enter password");
                    return;
                }
                powerMessage.displayMessage("Please Wait...");

                HiScores.createAccount(gamerName, password);
            }
        }
    }
    */


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

}
