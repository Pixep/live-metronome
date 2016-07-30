import QtQuick 2.5

import "../../controls"

Item {
    width: parent.width
    height: appStyle.controlHeight

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

    Row {
        anchors.fill: parent
        anchors.margins: appStyle.sidesMargin
        anchors.leftMargin: 2 * appStyle.sidesMargin
        scale: songMouseArea.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        BaseText {
            x: 0.15 * parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: (index+1) + "."
        }

        Item {
            width: 0.05 * parent.width
            height: parent.height
        }

        Item {
            width: 0.65 * parent.width
            height: parent.height

            BaseText {
                width: parent.width
                height: parent.height
                verticalAlignment: artistText.visible ? Text.AlignTop : Text.AlignVCenter
                text: title
                elide: Text.ElideRight
            }

            BaseText {
                id: artistText
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignBottom
                color: appStyle.textColor2
                font.pixelSize: appStyle.smallFontSize
                text: artist
                elide: Text.ElideRight
                visible: artist !== ""
            }
        }

        BaseText {
            width: 0.15 * parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: tempo + ""
        }
    }
    MouseArea {
        id: songMouseArea
        anchors.fill: parent
        onPressed: {
            metronome.songIndex = index
        }
        onPressAndHold: {
            actionDialog.show(index)
        }
    }
}
