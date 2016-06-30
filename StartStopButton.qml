import QtQuick 2.6

Item {
    height: 80
    width: parent.width

    property bool playing: false

    signal clicked()

    Button {
        id: playButton
        anchors.fill: parent
        text: parent.playing ? "Stop" : "Play"

        onClicked: {
            parent.clicked()
        }

        Rectangle {
            color: "red"
            width: height
            height: 0.5 * parent.height
            visible: root.active && root.tickIndex % 2 == 1
            anchors.right: parent.right
            anchors.rightMargin: 0.5 * height
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
