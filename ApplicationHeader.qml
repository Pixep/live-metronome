import QtQuick 2.6

Item {
    width: parent.width
    height: 80

    signal back()
    signal showMenu()

    Button {
        id: backButton
        height: parent.height
        width: height
        text: "<"
        onClicked: parent.back()
    }

    Text {
        anchors.left: backButton.right
        anchors.right: menuButton.left
        height: parent.height

        font.pixelSize: 25
        text: "Live Metronome"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        id: menuButton
        height: parent.height
        width: height
        anchors.right: parent.right
        text: "="
        onClicked: parent.showMenu()
    }
}
