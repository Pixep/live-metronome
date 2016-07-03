import QtQuick 2.6

Item {
    width: parent.width
    height: 80

    signal back()
    signal showMenu()

    Rectangle {
        anchors.fill: parent
        color: appStyle.headerColor
    }

    Button {
        id: backButton
        height: parent.height
        width: height
        imageSource: "qrc:/images/icon_back.png"
        radius: 0
        color: "transparent"
        onClicked: parent.back()
    }

    BaseText {
        anchors.left: backButton.right
        anchors.right: menuButton.left
        height: parent.height
        font.pixelSize: appStyle.titleFontSize
        text: "Live Metronome"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        id: menuButton
        height: parent.height
        width: height
        imageSource: "qrc:/images/icon_menu.png"
        anchors.right: parent.right
        radius: 0
        color: "transparent"
        onClicked: parent.showMenu()
    }
}
