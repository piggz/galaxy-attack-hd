import QtQuick 2.0

Image {
    id: closebutton
    signal clicked

    source: "pics/x.svg"
    width: Helper.mmToPixels(5)
    height: width

    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.top: parent.top
    anchors.topMargin: 0

    fillMode: Image.PreserveAspectFit
    smooth: false

    MouseArea {
        id: closearea
        anchors.fill: parent
        onClicked: {
            closebutton.clicked();
        }
    }
}
