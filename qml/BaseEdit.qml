import QtQuick 2.5

FocusScope {
    id: root
    height: appStyle.controlHeight

    property bool isNumber: false
    property bool focusNextOnEnter: false
    property alias text: textInput.text

    property Item previousFocused
    property Item nextFocused

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: appStyle.sidesMargin
        anchors.rightMargin: appStyle.sidesMargin
        anchors.bottomMargin: appStyle.sidesMargin
        anchors.leftMargin: 0
        radius: appStyle.borderRadius
    }

    TextInput {
        id: textInput
        anchors.fill: parent
        anchors.margins: appStyle.sidesMargin
        font.pixelSize: appStyle.titleFontSize
        verticalAlignment: TextInput.AlignVCenter
        color: appStyle.textColorDark
        anchors.centerIn: parent
        inputMethodHints: root.isNumber ? Qt.ImhDigitsOnly : Qt.ImhNone
        focus: true
        KeyNavigation.tab: root.nextFocused
        KeyNavigation.backtab: root.previousFocused
        Keys.onPressed: {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
            {
                returnFocus()
                event.accepted = true;
            }
        }

        function returnFocus() {
            if (root.nextFocused && root.focusNextOnEnter)
                root.nextFocused.focus = true
            else
                root.focus = false
        }
    }
}
