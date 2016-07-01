import QtQuick 2.0

Item {
    id: dialog
    width: parent.width
    height: parent.height
    visible: false
    z: 100

    function show()
    {
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
        radius: 10
        anchors.centerIn: parent
        width: 0.8 * parent.width
        height: 0.8 * parent.height
        color: "#333"

        Column {
            anchors.fill: parent
            ActionDialogItem {
                text: "Update tempo"
                onClicked: {
                    dialog.hide()
                }
            }
            ActionDialogItem {
                text: "Edit"
                onClicked: {
                    dialog.hide()
                }
            }
            ActionDialogItem {
                text: "Delete"
                onClicked: {
                    dialog.hide()
                }
            }
        }
    }
}
