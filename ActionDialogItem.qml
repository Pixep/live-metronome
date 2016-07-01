import QtQuick 2.0

Item {
    height: 80
    width: parent.width

    property alias text: textItem.text

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
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: "gray"
    }
}
