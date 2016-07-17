import QtQuick 2.5

Item {
    id: dialog
    width: parent.width
    height: parent.height
    visible: false
    z: 100

    property int contextValue
    default property alias dialogActions: actionsColumn.children

    function show(value)
    {
        contextValue = value
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
