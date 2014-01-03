import QtQuick 2.0

Rectangle {
    id:container

    signal exitClicked
    property bool onScreen: false
    property color foreground: "#7DF9FF"

    color: "black"
    width: parent.width
    height: parent.height
    y: 0
    x: onScreen?0:-width
    border.color: foreground
    border.width: 6
    radius: 10

    Behavior on x {
        NumberAnimation {duration: 400}
    }

    MouseArea {
        //Fake area to stop click throughs
        anchors.fill: parent
    }

    Text {
        id: txtHeader
        text: "World rankings"
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
            id: headUser
            anchors.left: headPosition.right
            anchors.top: headPosition.top
            anchors.leftMargin: 10
            width: parent.width * 0.4

            text: "User"
            font.bold: true
            color: "white"
            font.pixelSize: Helper.mmToPixels(4)
        }

        Text {
            id:headStage

            anchors.left: headUser.right
            anchors.leftMargin: 10
            anchors.top: headUser.top
            width: parent.width * 0.2
            text: "Level"
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)

        }

        Text {
            id:headScore
            anchors.left: headStage.right
            anchors.leftMargin: 10
            anchors.top: headPosition.top
            width: parent.width * 0.3
            text: "Score"
            color: "white"
            font.bold: true
            font.pixelSize: Helper.mmToPixels(4)

        }
    }


    ListModel {
        id: model
    }

    Text {
        visible: !ScoreLoop.scoreAvailable
        anchors.centerIn: parent
        text: "Loading..."
        font.pixelSize: Helper.mmToPixels(3)
        color: "white"
    }

    ListView {
        clip: true
        anchors.top: headerText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: currentUser.bottom
        anchors.margins: 20
        model: ScoreLoop
        visible: ScoreLoop.scoreAvailable
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "black"
            border.width: 2
        }

        delegate: Rectangle {
            anchors.right: parent.right
            anchors.left: parent.left
            height: score.height + 10
            color: "transparent"

            Text {
                id: rank
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.05
                text: model.rank
                font.pixelSize: Helper.mmToPixels(3)
                color: "white"
            }

            Text {
                id: user
                anchors.left: rank.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.4
                text: model.user
                font.pixelSize: Helper.mmToPixels(3)
                color: "white"
            }

            Text {
                id: stage
                anchors.left: user.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.2
                text: model.stage / 100
                font.pixelSize: Helper.mmToPixels(3)
                color: "white"
            }

            Text {
                id: score
                anchors.left: stage.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.3
                text: model.score
                font.pixelSize: Helper.mmToPixels(3)
                color: "white"
            }

        }
    }

    Text {
        id: currentUser
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 8
        text: "Current user:" + ScoreLoop.userName
        font.pointSize: 7
        color: "white"
    }

    onOnScreenChanged: {
        if (onScreen) {
            console.log("Submitting score:", ScoreModel.bestScore(), ScoreModel.bestLevel());
            ScoreLoop.submitNewScore(ScoreModel.bestScore(), ScoreModel.bestLevel());
            ScoreLoop.requestScores()
        }
    }

    CloseButton {
        id: closebutton

        onClicked: {
            container.exitClicked();
        }
    }
}
