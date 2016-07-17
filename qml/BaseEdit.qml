import QtQuick 2.5

Item {
    height: appStyle.controlHeight

    property bool isNumber: false
    property alias text: textInput.text

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
        inputMethodHints: Qt.ImhDigitsOnly
    }
}
