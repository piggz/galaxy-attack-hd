import QtQuick 2.0

Item {
    id: spacelogo
    width: invaderimage.width
    height: 128
    state: "HIDDEN"
    property int offScreenLocation: 0
    property int onScreenLocation: 0

    Image {
        id: invaderimage
        source: "pics/attack.png"
        height: parent.height
        smooth:  true
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges { target: spacelogo; x: offScreenLocation}
        },
        State {
            name: "VISIBLE"
            PropertyChanges { target: spacelogo; x: onScreenLocation}
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.OutBounce; duration: 1000 }
    }
}

