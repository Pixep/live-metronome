import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Item {
    id: menu
    height: parent.height
    width: parent.width
    visible: false

    signal showed()
    signal closed()

    default property alias menuContent: menuContentItem.children
    property bool active: false

    property var showAnimation: null
    property var hideAnimation: null

    function __show() {
        if (active)
            return

        active = true
        showed()

        if (hideAnimation)
            hideAnimation.stop()
        else
            defaultHideAnimation.stop()

        if (showAnimation)
            showAnimation.start()
        else
            defaultShowAnimation.start()
    }
    function __close() {
        if (!active)
            return

        active = false
        closed()

        if (showAnimation)
            showAnimation.stop()
        else
            defaultShowAnimation.stop()

        if (hideAnimation)
            hideAnimation.start()
        else
            defaultHideAnimation.start()
    }

    function show()
    {
        __show()
    }

    function close()
    {
        __close()
    }

    SequentialAnimation {
        id: defaultShowAnimation

        PropertyAction {
            target: menuBackground
            property: "x"
            value: -menuBackground.width
        }
        PropertyAction {
            target: menu
            property: "visible"
            value: true
        }
        ParallelAnimation {
            NumberAnimation {
                target: menuBackground
                property: "x"
                to: 0
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: backgroundOverlay
                property: "opacity"
                to: 0.7
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
        PropertyAction {
            target: menuBackground
            property: "enabled"
            value: true
        }
    }

    SequentialAnimation {
        id: defaultHideAnimation

        PropertyAction {
            target: menuBackground
            property: "enabled"
            value: false
        }
        ParallelAnimation {
            NumberAnimation {
                target: menuBackground
                property: "x"
                to: -menuBackground.width
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: backgroundOverlay
                property: "opacity"
                to: 0
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
        PropertyAction {
            target: menu
            property: "visible"
            value: false
        }
    }

    Rectangle {
        id: backgroundOverlay
        opacity: 0
        height: window.height
        width: window.width
        color: "black"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                menu.close()
            }
        }
    }

    DropShadow {
        anchors.fill: menuBackground
        horizontalOffset: 0
        verticalOffset:0
        radius: 6
        samples: 4
        color: "#80000000"
        source: menuBackground
    }

    Rectangle {
        id: menuBackground
        height: parent.height
        width: menuContentItem.width
        color: "#333"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //Catch signal
            }
        }

        ColumnLayout {
            id: menuContentItem
            spacing: 0
        }
    }
}
