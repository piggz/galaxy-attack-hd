import QtQuick 2.0

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


    function reset()  {
        ship.visible = true;
    }
}
