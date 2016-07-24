import QtQuick 2.5

Item {
    id: dialog

    signal showed()
    signal closed()

    default property alias dialogContent: dialogContentItem.children

    function __show() {
        showed()
        closeAnimation.stop()
        showAnimation.start()
    }
    function __close() {
        closed()
        showAnimation.stop()
        closeAnimation.start()
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
        id: showAnimation

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
        id: closeAnimation

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
                duration: 250
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: dialogContentItem
                property: "scale"
                to: 0.8
                duration: 200
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
