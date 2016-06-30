import QtQuick 2.6

Rectangle {
    id: root
    color: "gray"
    opacity: mouseArea.pressed ? 0.6 : 1

    property alias text: textItem.text

    signal clicked()

    Text {
        id: textItem
        anchors.centerIn: parent
        font.pixelSize: 25
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
