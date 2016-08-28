import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    height: visible ? appStyle.controlHeight : 0
    Layout.fillWidth: true
    Layout.minimumWidth: iconItem.width + textItem.width + 2*appStyle.margin + 4*appStyle.margin

    property alias text: textItem.text
    property alias iconSource: iconItem.source
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

        Image {
            id: iconItem
            height: appStyle.controlHeight
            width: appStyle.controlHeight
            fillMode: Image.PreserveAspectFit
        }
        BaseText {
            id: textItem
            height: appStyle.controlHeight
            anchors.left: iconItem.right
            anchors.leftMargin: appStyle.margin
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
        height: 1
        anchors.bottom: parent.bottom
        color: appStyle.backgroundColor2
    }
}
