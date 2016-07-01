import QtQuick 2.5

Item {
    height: 80
    x: appStyle.sidesMargin
    width: parent.width - appStyle.sidesMargin * 2

    signal previous()
    signal next()

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        imageSource: "qrc:/images/icon_previous.png"

        onClicked: {
            parent.previous()
        }
    }

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        anchors.right: parent.right
        imageSource: "qrc:/images/icon_next.png"

        onClicked: {
            parent.next()
        }
    }
}
