import QtQuick 2.0

Item {
    id: spacelogo
    width: 400
    height: 128
    state: "HIDDEN"

    Image {
        id: spaceimage

        source: "pics/attack.svg"
        width: parent.width
        height: parent.height
        smooth:  true
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges { target: spacelogo; width: 0}
            PropertyChanges { target: spacelogo; height: 0}
        },
        State {
            name: "VISIBLE"
            PropertyChanges { target: spacelogo; width: 400}
            PropertyChanges { target: spacelogo; height: 128}
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "width"; easing.type: Easing.OutBounce; duration: 1000 }
        NumberAnimation { properties: "height"; easing.type: Easing.OutBounce; duration: 1000 }
    }
}

