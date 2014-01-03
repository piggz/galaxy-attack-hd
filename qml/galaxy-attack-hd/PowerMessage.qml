// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Item {
    id: powermessage
    property color foreground: "#7DF9FF"

    height: 50
    width:  parent.width - 100
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    visible: true
    state: "HIDDEN"

    z:20

    property string text: ""

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges { target: powermessage; opacity: 1}
            PropertyChanges { target: powermessage; visible: false}
            PropertyChanges { target: powermessage; scale: 1}
        },
        State {
            name: "VISIBLE"
            PropertyChanges { target: powermessage; opacity: 0}
            PropertyChanges { target: powermessage; visible: true}
            PropertyChanges { target: powermessage; scale: 3}
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InQuint; duration: 3000 }
        NumberAnimation { properties: "scale"; easing.type: Easing.Linear; duration: 3000 }
    }

    Text {
        id: messagetext
        text: parent.text
        font.pixelSize: 40
        font.bold: true
        color: foreground
        anchors.horizontalCenter: powermessage.horizontalCenter
        anchors.verticalCenter: powermessage.verticalCenter
        visible: true

        Timer {
            id: messagetimer
            interval:  3200
            running: false
            repeat: false
            onRunningChanged: {
                if (messagetimer.running) {
                    powermessage.state = "VISIBLE";
                }
            }

            onTriggered: {
                powermessage.state = "HIDDEN";
            }
        }
    }

    function displayMessage(theText)
    {
        powermessage.state = "HIDDEN";
        powermessage.text = theText
        powermessage.opacity = 1;
        powermessage.scale = 1;
        powerMessage.rotation = 0;
        messagetimer.restart();
    }
}
