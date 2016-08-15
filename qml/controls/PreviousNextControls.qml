import QtQuick 2.5

Item {
    height: appStyle.controlHeight * 1.25
    width: parent.width

    signal previous()
    signal next()

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        color: appStyle.headerColor
        imageSource: "qrc:/qml/images/icon_previous.png"

        onClicked: {
            parent.previous()
        }
    }

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        anchors.right: parent.right
        color: appStyle.headerColor
        imageSource: "qrc:/qml/images/icon_next.png"

        onClicked: {
            parent.next()
        }
    }
}
