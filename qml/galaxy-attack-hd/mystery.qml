import QtQuick 2.0
import "sizer.js" as Sizer

Item {
    id:mystery
    width: Sizer.mysteryWidth()
    height: Sizer.mysteryHeight()
    
    property int pointsAwarded: 300;

    AnimatedSprite {
        id: sprite
        anchors.fill: parent
        source: "pics/mother.png"
        frameCount: 9
        frameSync: true
        frameWidth: 141
        frameHeight: 82
        running: true
    }
}