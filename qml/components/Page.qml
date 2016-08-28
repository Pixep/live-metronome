import QtQuick 2.5

import "../controls"

Item {
    id: page
    x: window.width
    width: parent.width
    anchors.top: parent.top
    anchors.topMargin: 2 * appStyle.margin
    anchors.bottom: parent.bottom
    anchors.bottomMargin: appStyle.margin
    visible: false

    default property alias pageContent: pageContentItem.children
    property alias actionButtonsVisible: actionButtons.visible
    property alias saveButtonsVisible: saveButtons.visible
    property alias actionButtonLeft: leftActionButton
    property alias actionButtonRight: rightActionButton
    property alias p: p
    property bool active: false

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
            hideAnimation.stop()
            page.x = window.width
            page.visible = true
            page.focus = true
            showAnimation.start()
        }

        function __hide() {
            if (!page.active)
                return

            page.active = false
            showAnimation.stop()
            hideAnimation.start()
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

    NumberAnimation on x {
        id: showAnimation
        to: 0
        duration: 400
        easing.type: Easing.OutBack
    }

    SequentialAnimation {
        id: hideAnimation

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
