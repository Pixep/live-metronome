import QtQuick 2.5

Item {
    id: dialog
    visible: false
    opacity: 0

    signal showed()
    signal closed()

    default property alias dialogContent: dialogContentItem.children
    property bool active: false

    property var showAnimation: null
    property var hideAnimation: null

    function __show() {
        if (active)
            return

        active = true
        gui.registerDialog(dialog)

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
        gui.unregisterDialog(dialog)
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
            target: dialog
            property: "visible"
            value: true
        }
        PropertyAction {
            target: dialog
            property: "opacity"
            value: 0
        }
        PropertyAction {
            target: dialogContentItem
            property: "scale"
            value: 0.8
        }
        ParallelAnimation {
            NumberAnimation {
                target: dialog
                property: "opacity"
                to: 1
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: dialogContentItem
                property: "scale"
                to: 1
                duration: 250
                easing.type: Easing.OutBack
            }
        }
        PropertyAction {
            target: dialog
            property: "enabled"
            value: true
        }
    }

    SequentialAnimation {
        id: defaultHideAnimation

        PropertyAction {
            target: dialog
            property: "enabled"
            value: false
        }
        ParallelAnimation {
            NumberAnimation {
                target: dialog
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: dialogContentItem
                property: "scale"
                to: 0.8
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
        PropertyAction {
            target: dialog
            property: "visible"
            value: false
        }
    }

    Rectangle {
        opacity: 0.7
        anchors.fill: parent
        color: "black"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //Catch signal
            }
        }
    }

    Item {
        id: dialogContentItem
        anchors.fill: parent
    }
}
