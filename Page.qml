import QtQuick 2.0

Item {
    id: page
    x: parent.width+1
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
        x = parent.width + 1
        visible = true
        showAnimation.start()
    }

    function hide() {
        showAnimation.stop()
        hideAnimation.start()
    }

    Rectangle {
        x: -appStyle.sidesMargin
        width: pageContainer.backgroundWidth
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
        duration: 300
        easing.type: Easing.InOutQuad
    }

    NumberAnimation on x {
        id: hideAnimation
        to: parent.width+1
        duration: 300
        easing.type: Easing.InOutQuad
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
