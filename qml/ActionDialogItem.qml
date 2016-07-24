import QtQuick 2.5

Item {
    height: appStyle.controlHeight
    width: parent.width

    property alias text: textItem.text
    property alias showSeparator: separator.visible

    signal clicked

    Rectangle {
        anchors.fill: parent
        visible: mouseArea.pressed
        opacity: 0.3
    }

    BaseText {
        id: textItem
        anchors.centerIn: parent
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
