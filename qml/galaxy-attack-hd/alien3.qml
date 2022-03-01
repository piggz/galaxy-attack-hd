import QtQuick 2.2
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

    BlockEmitter {
        jewel: alien3
        id: particles
        system: board.particleSystem
        group: "red"
        anchors.fill: parent
    }

    RotationAnimator {
        target: alien3;
        from: 0;
        to: 360;
        duration: 5000
        running: applicationWindow.onScreen
        loops: -1
    }

    function explode() {
        particles.pulse(150);
        alien3.destroy(150);
    }

}
