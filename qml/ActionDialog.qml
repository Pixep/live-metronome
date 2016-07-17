import QtQuick 2.5

Item {
    id: dialog
    width: parent.width
    height: parent.height
    visible: false

    property int contextValue
    default property alias dialogActions: actionsColumn.children

    function show(value)
    {
        contextValue = value !== undefined ? value : -1
        visible = true
    }

    function hide()
    {
        visible = false
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

    Rectangle {
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
