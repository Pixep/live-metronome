import QtQuick 2.5

Rectangle {
    id: root
    color: appStyle.backgroundColor2
    opacity: {
        if (!enabled)
            return 0.3
        else if (mouseArea.pressed)
            return 0.5

        return 1
    }
    radius: appStyle.borderRadius

    property alias text: textItem.text
    property alias imageSource: imageItem.source
    property alias pressed: mouseArea.pressed

    signal buttonPressed()
    signal clicked()
    signal pressAndHold()
    signal released()

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
        onPressed: root.buttonPressed()
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
        onReleased: root.released()
    }
}
