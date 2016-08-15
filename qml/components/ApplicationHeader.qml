import QtQuick 2.6

import "../controls"

Item {
    id: header
    width: parent.width
    height: appStyle.controlHeight

    property alias backVisible: backButton.visible
    property alias menuVisible: menuButton.visible
    property bool menuEnabled: true

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
        imageSource: "qrc:/qml/images/icon_back.png"
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
        imageSource: "qrc:/qml/images/icon_menu.png"
        anchors.right: parent.right
        radius: 0
        color: "transparent"
        opacity: header.menuEnabled ? 1 : 0.3
        onClicked: {
            if (header.menuEnabled)
                parent.showMenu()
            else
                toast.show("Menu disabled during play")
        }
    }
}
