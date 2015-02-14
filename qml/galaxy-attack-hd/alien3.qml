import QtQuick 2.0
import QtQuick.Particles 2.0

import "sizer.js" as Sizer

Item {
    id: alien3

    state: "FRAME0"
    width: Sizer.alien3width()
    height: alien3frame1.height

    property int pointsAwarded: 10

    Image {
        id: alien3frame1
        source: "pics/alien3.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    Image {
        id: alien3frame2
        source: "pics/alien3.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    BlockEmitter {
        jewel: alien3
        id: particles
        system: board.particleSystem
        group: "red"
        anchors.fill: parent
    }

    function explode() {
        particles.pulse(150);
        alien3.destroy(150);
    }

    states: [
        State {
            name: "FRAME0"
            PropertyChanges { target: alien3frame1; visible: true}
            PropertyChanges { target: alien3frame2; visible: false}
        },
        State {
            name: "FRAME1"
            PropertyChanges { target: alien3frame1; visible: false}
            PropertyChanges { target: alien3frame2; visible: true}
        }
    ]

    }
