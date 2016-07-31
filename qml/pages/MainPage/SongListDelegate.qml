import QtQuick 2.5

import "../../controls"

Item {
    width: parent.width
    height: appStyle.controlHeight

    readonly property int songTempo: tempo

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
        anchors.leftMargin: 3 * appStyle.sidesMargin
        anchors.rightMargin: 3 * appStyle.sidesMargin
        scale: songMouseArea.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        BaseText {
            width: 0.10 * parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: (index+1) + "."
        }

        Item {
            width: 0.75 * parent.width
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
            horizontalAlignment: Text.AlignRight
            text: tempo + ""
        }
    }
    MouseArea {
        id: songMouseArea
        anchors.fill: parent
        onClicked: {
            metronome.songIndex = index
        }
        onPressAndHold: {
            actionDialog.show(index)
        }
    }
}
