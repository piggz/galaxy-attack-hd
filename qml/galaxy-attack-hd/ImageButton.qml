import QtQuick 2.0

//Start button
Item {
    id: imgButton
    property string image: ""
    property bool highlighed: false
    property bool selected: false
    property color highlightColor: "#ffffff"
    signal clicked

    height: width

    Rectangle {
        x: -10
        y: -10

        width: parent.width + 20
        height: parent.height + 20
        radius: width/2
        visible: selected
        color: highlightColor
    }

    Image {
        anchors.fill: parent
        source: image

        Rectangle {
            anchors.centerIn: parent
            width: 30
            height: 30
            radius: 15
            color: "#ff9900"
            visible: highlighed
        }
    }

    MouseArea {
        id: buttonStartArea
        anchors.fill: parent
        onClicked: {
            imgButton.clicked();
        }
    }
}
