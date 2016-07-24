import QtQuick 2.0

Item {
    id: page
    x: window.width
    width: parent.width
    anchors.top: parent.top
    anchors.topMargin: 2 * appStyle.sidesMargin
    anchors.bottom: parent.bottom
    anchors.bottomMargin: appStyle.sidesMargin
    visible: false

    default property alias pageContent: pageContentItem.children
    property alias actionButtonsVisible: actionButtons.visible
    property alias actionButtonLeft: leftActionButton
    property alias actionButtonRight: rightActionButton

    signal actionButtonLeftClicked()
    signal actionButtonRightClicked()

    function show() {
        hideAnimation.stop()
        x = window.width
        visible = true
        page.focus = true
        showAnimation.start()
    }

    function hide() {
        showAnimation.stop()
        hideAnimation.start()
    }

    Rectangle {
        x: -appStyle.sidesMargin
        width: 1.5 * pageContainer.backgroundWidth // Larger than page for animation overshoot
        height: pageContainer.backgroundHeight
        color: appStyle.backgroundColor
    }

    Item {
        id: pageContentItem
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: actionButtons.visible ? actionButtons.top : parent.bottom
        anchors.bottomMargin: actionButtons.visible ? appStyle.sidesMargin : 0
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
        spacing: appStyle.sidesMargin
        visible: false

        Button {
            id: leftActionButton
            text: qsTr("Cancel")
            width: appStyle.width_col3
            height: appStyle.controlHeight
            onClicked: {
                page.actionButtonLeftClicked();
            }
        }
        Button {
            id: rightActionButton
            text: qsTr("Save")
            width: appStyle.width_col3
            height: appStyle.controlHeight
            onClicked: {
                page.actionButtonRightClicked();
            }
        }
    }
}
