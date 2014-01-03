import QtQuick 2.0

Item {
    property string optionText
    property int optionTextSize
    property color optionColor: "#7DF9FF"

    signal optionClicked (bool val)

    Rectangle {
        id: optionButton
        height: parent.height
        width: height
        x: 20

        border.color: "#7DF9FF"
        border.width: 5
        state: parent.state

        states: [
            State {
                name: "TRUE"
                PropertyChanges { target: optionButton; color: "#7DF9FF"}
            },
            State {
                name: "FALSE"
                PropertyChanges { target: optionButton; color: "#000000"}
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked: {
                click();
            }
        }

    }
    Text {
        id: optionTextString
        text: optionText
        font.pixelSize: optionTextSize
        color: optionColor
        anchors.left: optionButton.right
        anchors.leftMargin: 20
        anchors.verticalCenter: optionButton.verticalCenter
    }

    function click() {
        if (optionButton.state == "FALSE") {
            optionButton.state = "TRUE";
        } else {
            optionButton.state = "FALSE";
        }
        optionClicked(optionButton.state == "TRUE" ? true : false);
    }
}
