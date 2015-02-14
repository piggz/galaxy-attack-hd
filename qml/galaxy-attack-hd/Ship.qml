import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: ship
    width: shipframe.width
    height: shipframe.height

    Image {
        id: shipframe
        width: 60
        height: 30
        source: "pics/ship.png"
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
