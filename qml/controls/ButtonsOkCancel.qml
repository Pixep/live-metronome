import QtQuick 2.0

Item {
    height: appStyle.controlHeight
    width: parent.width

    signal accepted()
    signal refused()

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        color: appStyle.headerColor
        iconSource: "qrc:/qml/images/icon_clear.png"

        onClicked: {
            parent.refused()
        }
    }

    Button {
        height: parent.height
        width: parent.width / 2 - 5
        anchors.right: parent.right
        color: appStyle.headerColor
        iconSource: "qrc:/qml/images/icon_check.png"

        onClicked: {
            parent.accepted()
        }
    }
}
