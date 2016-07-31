import QtQuick 2.5

BaseDialog {
    id: dialog
    width: parent.width
    height: parent.height
    visible: false
    opacity: 0

    property int contextValue
    property int contextValue2
    default property alias dialogActions: actionsColumn.children

    function show(value, value2) {
        contextValue = value !== undefined ? value : -1
        contextValue2 = value2 !== undefined ? value2 : -1
        __show()
    }

    Rectangle {
        id: dialogContent
        radius: appStyle.borderRadius
        anchors.centerIn: parent
        width: 0.8 * parent.width
        height: childrenRect.height + radius * 2
        color: "#333"

        Column {
            id: actionsColumn
            y: appStyle.borderRadius
            width: parent.width
            height: childrenRect.height
        }
    }
}
