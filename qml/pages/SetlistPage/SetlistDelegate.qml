import QtQuick 2.5

import "../../controls"

Item {
    id: delegate
    width: parent.width
    height: appStyle.controlHeight

    property alias nameText: nameItem.text
    property alias subtitleText: sougsCountItem.text

    signal clicked()
    signal pressAndHold()

    Rectangle {
        color: appStyle.headerColor
        anchors.fill: parent
        opacity: songMouseArea.pressed ? 0.6 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 800
                easing.type: Easing.OutQuad
            }
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: appStyle.margin
        anchors.leftMargin: 3 * appStyle.margin
        anchors.rightMargin: 3 * appStyle.margin
        scale: songMouseArea.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        BaseText {
            id: nameItem
            width: parent.width
            height: parent.height
            verticalAlignment: Text.AlignTop
            elide: Text.ElideRight
        }

        BaseText {
            id: sougsCountItem
            width: parent.width
            height: parent.height
            verticalAlignment: Text.AlignBottom
            color: appStyle.textColor2
            font.pixelSize: appStyle.smallFontSize
            elide: Text.ElideRight
            visible: text !== ""
        }
    }

    MouseArea {
        id: songMouseArea
        anchors.fill: parent
        onClicked: {
            delegate.clicked();
        }
        onPressAndHold: {
            delegate.pressAndHold()
        }
    }
}
