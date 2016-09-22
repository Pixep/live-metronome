import QtQuick 2.5

import "../controls"

Item {
    id: page
    width: parent.width
    height: bottomY - topY
    y: topY
    visible: false

    readonly property int topY: 2 * appStyle.margin
    readonly property int bottomY: parent.height - appStyle.margin
    default property alias pageContent: pageContentItem.children
    property alias actionButtonsVisible: actionButtons.visible
    property alias saveButtonsVisible: saveButtons.visible
    property alias actionButtonLeft: leftActionButton
    property alias actionButtonRight: rightActionButton
    property alias p: p
    property bool active: false
    property var showAnimation: null
    property var hideAnimation: null

    signal actionButtonLeftClicked()
    signal actionButtonRightClicked()
    signal save()
    signal discard()

    QtObject {
        id: p

        function __show() {
            if (page.active)
                return

            page.active = true

            if (hideAnimation)
                hideAnimation.stop()
            else
                defaultHideAnimation.stop()

            page.visible = true
            page.focus = true

            if (showAnimation)
                showAnimation.start()
            else
                defaultShowAnimation.start()
        }

        function __hide() {
            if (!page.active)
                return

            page.active = false

            if (showAnimation)
                showAnimation.stop()
            else
                defaultShowAnimation.stop()

            if (hideAnimation)
                hideAnimation.start()
            else
                defaultHideAnimation.start()
        }
    }

    function show() {
        p.__show()
    }

    function hide() {
        p.__hide()
    }

    Rectangle {
        x: -appStyle.margin
        width: 1.5 * pageContainer.backgroundWidth // Larger than page for animation overshoot
        height: pageContainer.backgroundHeight
        color: appStyle.backgroundColor

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }
    }

    Item {
        id: pageContentItem
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: actionButtons.visible ? actionButtons.top : parent.bottom
        anchors.bottomMargin: actionButtons.visible ? appStyle.margin : 0
    }

    SequentialAnimation {
        id: defaultShowAnimation

        PropertyAction {
            target: page
            property: "x"
            value: page.width
        }

        NumberAnimation {
            target: page
            property: "x"
            to: 0
            duration: 400
            easing.type: Easing.OutBack
        }
    }

    SequentialAnimation {
        id: defaultHideAnimation

        PropertyAnimation {
            target: page
            property: "x"
            to: window.width
            duration: 300
            easing.type: Easing.InCubic
        }
        PropertyAction {
            target: page
            property: "visible"
            value: false
        }
    }

    Row {
        id: actionButtons
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: appStyle.margin
        visible: false

        Button {
            id: leftActionButton
            width: appStyle.width_col3
            height: appStyle.controlHeight
            onClicked: {
                page.actionButtonLeftClicked();
            }
        }
        Button {
            id: rightActionButton
            width: appStyle.width_col3
            height: appStyle.controlHeight
            onClicked: {
                page.actionButtonRightClicked();
            }
        }
    }

    ButtonsOkCancel {
        id: saveButtons
        anchors.bottom: parent.bottom
        visible: false

        onAccepted: {
            page.save()
        }
        onRefused: {
            page.discard()
        }
    }
}
