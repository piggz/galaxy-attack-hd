import QtQuick 2.0
import QtQuick.Particles 2.0

import "sizer.js" as Sizer

Item {
    id:alien1
    state: "FRAME0"
    width: Sizer.alien1width()
    height: alien1frame1.height

    property int pointsAwarded: 30
    Image {
        id: alien1frame1
        source: "pics/alien1.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
    }

    Image {
        id: alien1frame2
        source: "pics/alien1.png"
        width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: false
    }

    BlockEmitter {
        jewel: alien1
        id: particles
        system: board.particleSystem
        group: "red"
        anchors.fill: parent
    }

    function explode() {
        particles.pulse(150);
        alien1.destroy(150);
    }


    states: [
        State {
            name: "FRAME0"
            PropertyChanges { target: alien1frame1; visible: true}
            PropertyChanges { target: alien1frame2; visible: false}
        },
        State {
            name: "FRAME1"
            PropertyChanges { target: alien1frame1; visible: false}
            PropertyChanges { target: alien1frame2; visible: true}
        }
    ]
}
