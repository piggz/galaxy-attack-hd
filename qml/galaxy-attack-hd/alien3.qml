import QtQuick 2.0
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
