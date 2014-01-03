import QtQuick 2.0

Item {
    id:explosion
    width: 44
    height: 32

    function play() {
        explosion.visible = true;
        sprite.start();

    }

    AnimatedSprite {
        id: sprite
        anchors.fill: parent
        source: "pics/explosion.png"
        frameCount: 16
        frameSync: true
        frameWidth: 256
        frameHeight: 256
        loops: 1
        visible: parent.visible

        onRunningChanged: {
            if (!running) {
                explosion.visible = false;
            }
        }
        onCurrentFrameChanged: {
            if (currentFrame === 15) {
                explosion.visible = false;
            }
        }

    }


}
