import QtQuick 2.6

Item {
    height: 80
    width: parent.width

    signal previous()
    signal next()

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        text: "<|"

        onClicked: {
            parent.previous()
        }
    }

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        anchors.right: parent.right
        text: "|>"

        onClicked: {
            parent.next()
        }
    }
}
