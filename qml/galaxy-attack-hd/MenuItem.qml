import QtQuick 2.0
import "sizer.js" as Sizer;

Item {
    property string menuText
    property string menuImage
    property color menuColor
    signal menuItemClicked

    width: menuItemImage.width + menuItemText.width + 10

    Image {
        id: menuItemImage
        source: menuImage
        anchors.left: parent.left
        anchors.top: parent.top
        height: parent.height
        width: height
        smooth: false
    }

    Text {
        text: menuText
        id: menuItemText
        anchors.left: menuItemImage.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: menuColor
        font.pixelSize: parent.height
    }

    MouseArea {
        id: settingsarea
        anchors.fill: parent
        onClicked: {
            menuItemClicked()
        }
    }

    function click() {
        menuItemClicked();
    }
}
