import QtQuick 2.0
import QtQuick.Particles 2.0

import "sizer.js" as Sizer

Item {
    id: alien2
    state: "FRAME0"
    width: Sizer.alien2width()
    height: alien2frame1.height

    property int pointsAwarded: 20

    Image {
        id: alien2frame1
        source: "pics/alien2.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    Image {
        id: alien2frame2
        source: "pics/alien2.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    BlockEmitter {
        jewel: alien2
        id: particles
        system: board.particleSystem
        group: "red"
        anchors.fill: parent
    }

    function explode() {
        particles.pulse(150);
        alien2.destroy(150);
    }

    states: [
        State {
            name: "FRAME0"
            PropertyChanges { target: alien2frame1; visible: true}
            PropertyChanges { target: alien2frame2; visible: false}
        },
        State {
            name: "FRAME1"
            PropertyChanges { target: alien2frame1; visible: false}
            PropertyChanges { target: alien2frame2; visible: true}
        }
    ]

}