import QtQuick 2.5

Item {
    width: parent.width
    height: childrenRect.height

    property alias label: labelItem.text
    property string value: edit.text

    BaseText {
        id: labelItem
        width: 0.6*parent.width
        height: appStyle.controlHeight
    }

    TextEdit {
        id: edit
        width: 0.4*parent.width
        height: appStyle.controlHeight
        font.pixelSize: appStyle.baseFontSize
        color: appStyle.textColor
    }
}
