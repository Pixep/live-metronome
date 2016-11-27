import QtQuick 2.6
import QtGraphicalEffects 1.0

import "../controls"

Item {
    id: header
    width: parent.width
    height: appStyle.controlHeight

    property alias backVisible: backButton.visible
    property alias menuVisible: menuButton.visible
    property alias title: title.text
    property bool menuEnabled: true
    property string menuDisabledMessage

    signal back()
    signal showMenu()
    signal titleClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        color: appStyle.headerColor
    }

    DropShadow {
        anchors.fill: background
        horizontalOffset: 0
        verticalOffset:0
        radius: 6
        samples: 4
        color: "#80000000"
        source: background
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
        id: title
        anchors.left: menuLeftAnchor.right
        anchors.right: menuRightAnchor.left
        height: parent.height
        font.pixelSize: appStyle.titleFontSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: header.title

        MouseArea {
            id: titleMouseArea
            anchors.fill: parent
            onClicked: header.titleClicked()
        }
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
                toast.show(menuDisabledMessage)
        }
    }
}
