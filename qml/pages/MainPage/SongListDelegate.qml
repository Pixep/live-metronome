import QtQuick 2.5

import "../../controls"

Item {
    id: delegate
    width: parent.width
    height: appStyle.controlHeight

    readonly property string songNumber: (typeof index !== 'undefined') ? (index+1).toString() : ""
    readonly property int songTempo: (typeof tempo !== 'undefined') ? tempo : -1
    property alias titleText: titleItem.text
    property alias artistText: artistItem.text
    property bool showNumber: true
    property alias songNumberItem: numberItem

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

    Row {
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
            id: numberItem
            width: 0.10 * parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: delegate.showNumber ? delegate.songNumber + "." : ""
        }

        Item {
            width: 0.75 * parent.width
            height: parent.height

            BaseText {
                id: titleItem
                width: parent.width
                height: parent.height
                verticalAlignment: artistItem.visible ? Text.AlignTop : Text.AlignVCenter
                elide: Text.ElideRight
            }

            BaseText {
                id: artistItem
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignBottom
                color: appStyle.textColor2
                font.pixelSize: appStyle.smallFontSize
                elide: Text.ElideRight
                visible: text !== ""
            }
        }

        BaseText {
            width: 0.15 * parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            text: songTempo > 0 ? tempo.toString() : ""
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
