import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    height: visible ? appStyle.controlHeight : 0
    Layout.fillWidth: true
    Layout.minimumWidth: iconItem.width + textItem.width + 2*appStyle.margin + 6*appStyle.margin

    property alias text: textItem.text
    property alias iconSource: iconItem.source
    property real iconScale: 1
    property alias showSeparator: separator.visible

    signal clicked

    Rectangle {
        anchors.fill: parent
        visible: mouseArea.pressed
        opacity: 0.3
    }

    Item {
        id: contentItem
        x: appStyle.margin

        Rectangle {
            id: circle
            y: 0.25 * appStyle.controlHeight
            x: 0.15 * appStyle.controlHeight
            height: 0.55 * appStyle.controlHeight
            width: 0.55 * appStyle.controlHeight
            anchors.margins: - 0.05 * appStyle.controlHeight
            radius: width / 2
            color: appStyle.headerColor
        }

        Image {
            id: iconItem
            anchors.centerIn: circle
            height: iconScale * 0.5 * appStyle.controlHeight
            width: iconScale * 0.5 * appStyle.controlHeight
            fillMode: Image.PreserveAspectFit
        }
        BaseText {
            id: textItem
            height: appStyle.controlHeight
            anchors.left: iconItem.right
            anchors.leftMargin: appStyle.margin + 0.1 * appStyle.controlHeight
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            parent.clicked()
        }
    }

    Rectangle {
        id: separator
        width: parent.width
        height: 0
        anchors.bottom: parent.bottom
        color: appStyle.backgroundColor2
    }
}
