import QtQuick 2.5

Rectangle {
    id: root
    color: appStyle.backgroundColor2
    radius: appStyle.borderRadius
    opacity: {
        if (!enabled)
            return 0.3
        else if (mouseArea.pressed)
            return 0.5

        return 1
    }

    property alias text: textItem.text
    property alias iconSource: imageItem.source
    property real iconScale: 1
    property alias pressed: mouseArea.pressed
    property alias textItem: textItem

    signal buttonPressed()
    signal clicked()
    signal pressAndHold()
    signal released()

    BaseText {
        id: textItem
        anchors.fill: parent
        anchors.margins: 4
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Image {
        id: imageItem
        anchors.centerIn: parent
        height: iconScale * parent.height
        width: iconScale * parent.width
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
