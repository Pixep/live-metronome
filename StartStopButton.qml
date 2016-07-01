import QtQuick 2.5

Item {
    id: root
    height: 80
    x: appStyle.sidesMargin
    width: parent.width - 2 * appStyle.sidesMargin

    property bool playing: false
    property int tickIndex

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
            visible: root.playing && root.tickIndex % 2 == 1
            anchors.right: parent.right
            anchors.rightMargin: 0.5 * height
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
