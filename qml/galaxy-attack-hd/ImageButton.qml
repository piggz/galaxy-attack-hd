import QtQuick 2.0

//Start button
Item {
    id: imgButton
    property string image: ""
    property bool highlighed: false;

    signal clicked

    height: width

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
