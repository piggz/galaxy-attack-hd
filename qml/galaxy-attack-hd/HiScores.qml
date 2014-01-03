import QtQuick 2.0

Rectangle {
    id: container

    signal exitClicked
    property bool onScreen: false
    property color foreground: "#7DF9FF"


    color: "black"
    width: parent.width
    height: parent.height
    y: 0
    x: onScreen?0:width
    border.color: foreground
    border.width: 6
    radius: 10

    Behavior on x {
        NumberAnimation {duration: 400}
    }

    Text {
        id: txtHeader
        text: "Hi-Scores"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        font.pointSize: 18
        color: foreground
        font.bold: true
    }

    Item {
        id: headerText
        anchors.top: txtHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: headPosition.height + 8

        Text {
            id: headPosition
            y:4
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width * 0.05

            text: ""
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)
        }

        Text {
            id: headScore
            anchors.left: headPosition.right
            anchors.top: headPosition.top
            anchors.leftMargin: 10
            width: parent.width * 0.2

            text: "Score"
            font.bold: true
            color: "white"
            font.pixelSize: Helper.mmToPixels(4)
        }

        Text {
            id:headStage

            anchors.left: headScore.right
            anchors.leftMargin: 10
            anchors.top: headScore.top
            width: parent.width * 0.3
            text: "Stage"
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)

        }

        Text {
            id:headLevel
            anchors.left: headStage.right
            anchors.leftMargin: 10
            anchors.top: headScore.top
            width: parent.width * 0.2
            text: "Level"
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)

        }
        Text {
            id:headDate
            anchors.left: headLevel.right
            anchors.leftMargin: 10
            anchors.top: headScore.top
            width: parent.width * 0.2
            text: "Date"
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)

        }
    }


    ListView {
        anchors.top: headerText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.margins: 10

        clip: true
        model: ScoreModel
        delegate: hiScoreDelegate
    }

    CloseButton {
        id: closebutton

        onClicked: {
            console.log("close hiscore");
            container.exitClicked();
        }
    }

    Component {
        id: hiScoreDelegate

        Item {
            width: parent.width
            height: levelRectangle.height

            Item {
                id: levelRectangle
                width:parent.width
                height: txtScore.height + 8
                clip: true

                Text {
                    id: txtPosition
                    y:4
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width * 0.05
                    color: "#ffffff"
                    text: scoreposition
                    font.pixelSize: Helper.mmToPixels(4)
                }

                Text {
                    id: txtScore
                    anchors.left: txtPosition.right
                    anchors.top: txtPosition.top
                    anchors.leftMargin: 10
                    width: parent.width * 0.2
                    color: "#ffffff"
                    text: score
                    font.pixelSize: Helper.mmToPixels(4)
                }

                Text {
                    id:txtStage

                    anchors.left: txtScore.right
                    anchors.leftMargin: 10
                    anchors.top: txtPosition.top
                    width: parent.width * 0.3
                    text: scorelevelname
                    color: "#ffffff"
                    font.pixelSize: Helper.mmToPixels(4)

                }

                Text {
                    id:txtLevel
                    anchors.left: txtStage.right
                    anchors.leftMargin: 10
                    anchors.top: txtPosition.top
                    width: parent.width * 0.2
                    text: ((scorestage * 100) + scorecurrentlevel) / 100
                    color: "#ffffff"
                    font.pixelSize: Helper.mmToPixels(4)
                }

                Text {
                    id:txtdDate
                    anchors.left: txtLevel.right
                    anchors.leftMargin: 10
                    anchors.top: txtPosition.top
                    width: parent.width * 0.2
                    text: scoredate
                    color: "#ffffff"
                    font.pixelSize: Helper.mmToPixels(4)

                }

            }

        }
    }
}



