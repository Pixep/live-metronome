import QtQuick 2.5

Item {
    height: appStyle.controlHeight
    width: parent.width

    signal previous()
    signal next()

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        imageSource: "qrc:/qml/images/icon_previous.png"

        onClicked: {
            parent.previous()
        }
    }

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        anchors.right: parent.right
        imageSource: "qrc:/qml/images/icon_next.png"

        onClicked: {
            parent.next()
        }
    }
}
