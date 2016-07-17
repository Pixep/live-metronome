import QtQuick 2.5

Rectangle {
    id: root
    color: appStyle.backgroundColor2
    opacity: mouseArea.pressed ? 0.5 : 1
    radius: appStyle.borderRadius

    property alias text: textItem.text
    property alias imageSource: imageItem.source

    signal clicked()

    BaseText {
        id: textItem
        anchors.centerIn: parent
    }

    Image {
        id: imageItem
        anchors.centerIn: parent
        height: 0.6 * parent.height
        width: 0.6 * parent.width
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
