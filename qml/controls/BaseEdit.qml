import QtQuick 2.5

FocusScope {
    id: root
    height: appStyle.controlHeight

    property bool isNumber: false
    property bool focusNextOnEnter: false
    property alias text: textInput.text
    property bool inputValid: true

    property Item previousFocused
    property Item nextFocused

    signal validateInput()

    function validate()
    {
        validateInput()
    }

    onTextChanged: {
        validate()
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: appStyle.margin
        radius: appStyle.borderRadius
        border.width: inputValid ? 0 : height / 15
        border.color: "#DD2222"

        Behavior on border.width {
            NumberAnimation {
                easing.overshoot: 5
                duration: 350
                easing.type: Easing.OutBack
            }
        }
    }

    TextInput {
        id: textInput
        anchors.fill: parent
        anchors.margins: appStyle.margin
        anchors.rightMargin: 2*appStyle.margin
        anchors.leftMargin: 2*appStyle.margin
        font.pixelSize: appStyle.titleFontSize
        verticalAlignment: TextInput.AlignVCenter
        color: appStyle.textColorDark
        anchors.centerIn: parent
        inputMethodHints: root.isNumber ? Qt.ImhDigitsOnly : Qt.ImhNoPredictiveText
        focus: true
        maximumLength: 32
        KeyNavigation.tab: root.nextFocused
        KeyNavigation.backtab: root.previousFocused
        Keys.onPressed: {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
            {
                event.accepted = true;
                returnFocus()
            }
        }

        function returnFocus() {
            if (root.nextFocused && root.focusNextOnEnter)
                root.nextFocused.focus = true
            else
                contentRoot.focus = true
        }
    }
}
