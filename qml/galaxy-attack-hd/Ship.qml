import QtQuick 2.0
import QtQuick.Particles 2.0
import "sizer.js" as Sizer;

Item {
    id: ship
    width: shipframe.width
    height: shipframe.height

    Image {
        id: shipframe
        width: Sizer.alien1width()
        height: width/2
        source: "pics/ship2.png"
        smooth: true
        fillMode: Image.Stretch
    }

    BlockEmitter {
        jewel: ship
        id: particles
        system: board.particleSystem
        group: "blue"
        anchors.fill: parent
    }

    function explode() {
        particles.pulse(200);
    }

    function reset()  {
        ship.visible = true;
    }
}
