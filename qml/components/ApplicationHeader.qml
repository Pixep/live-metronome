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
        iconSource: "qrc:/qml/images/icon_back.png"
        iconScale: 0.8
        radius: 0
        color: "transparent"
        onClicked: parent.back()
    }

    Item {
        id: menuLeftAnchor
        height: parent.height
        width: height
        x: appStyle.margin
    }

    BaseText {
        anchors.left: menuLeftAnchor.right
        anchors.right: menuRightAnchor.left
        height: parent.height
        font.pixelSize: appStyle.titleFontSize
        text: userSettings.setlist ? userSettings.setlist.name : "Live Metronome"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: menuRightAnchor
        anchors.right: parent.right
        height: parent.height
        width: height
    }

    Button {
        id: menuButton
        anchors.fill: parent
        parent: platform.isAndroid ? menuLeftAnchor : menuRightAnchor
        iconSource: "qrc:/qml/images/icon_menu.png"
        iconScale: 0.8
        radius: 0
        color: "transparent"
        opacity: header.menuEnabled ? 1 : 0.3
        onClicked: {
            if (header.menuEnabled)
                header.showMenu()
            else
                toast.show(qsTr("Menu disabled during play"))
        }
    }
}
