import QtQuick 2.0

Item {
    id: hdlogo
    width: 128
    height: 128
    state: "HIDDEN"

    Image {
        id: imgStar

        source: "pics/star.svg"
        width: parent.width
        height: parent.height
        smooth:  true
        anchors.centerIn: parent
    }

    Image {
        id: imgHd

        source: "pics/hd.png"
        width: parent.width / 3
        height: parent.height / 3
        smooth:  true
        anchors.centerIn: imgStar
    }

    Timer {
        id: tmrStarRotate
        running: true
        repeat: true
        interval: 1000/60
        onTriggered: {
            imgStar.rotation += 1;
            if (imgStar.rotation >= 360) {
                imgStar.rotation = 0;
            }
        }
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges { target: hdlogo; opacity: 0}
        },
        State {
            name: "VISIBLE"
            PropertyChanges { target: hdlogo; opacity: 1}
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.OutBounce; duration: 1000 }
    }
}
