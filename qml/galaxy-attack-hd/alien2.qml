import QtQuick 2.0
import "sizer.js" as Sizer

Item {
    id: alien2
    state: "FRAME0"
    width: Sizer.alien2width()
    height: Sizer.alien2height()

    property int pointsAwarded: 20

    Image {
        id: alien2frame1
        source: "pics/orangeship1.png"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    Image {
        id: alien2frame2
        source: "pics/orangeship1.png"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        smooth: false
        }

    states: [
        State {
            name: "FRAME0"
            PropertyChanges { target: alien2frame1; visible: true}
            PropertyChanges { target: alien2frame2; visible: false}
        },
        State {
            name: "FRAME1"
            PropertyChanges { target: alien2frame1; visible: false}
            PropertyChanges { target: alien2frame2; visible: true}
        }
    ]

}
