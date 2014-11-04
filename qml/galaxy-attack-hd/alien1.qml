import QtQuick 2.0
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
