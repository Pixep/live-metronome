import QtQuick 2.0

Item {
    id: dialog
    width: parent.width
    height: parent.height
    visible: false
    z: 100

    property int actionSongIndex

    signal updateSongTempo()
    signal editSong()
    signal removeSong()

    function show(songIndex)
    {
        actionSongIndex = songIndex
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
            y: appStyle.borderRadius
            width: parent.width
            height: childrenRect.height
            ActionDialogItem {
                text: "Update tempo"
                onClicked: {
                    dialog.hide()
                    dialog.updateSongTempo()
                }
            }
            ActionDialogItem {
                text: "Edit"
                onClicked: {
                    dialog.hide()
                    dialog.editSong()
                }
            }
            ActionDialogItem {
                text: "Delete"
                onClicked: {
                    dialog.hide()
                    dialog.removeSong()
                }
            }
            ActionDialogItem {
                text: "Cancel"
                showSeparator: false
                onClicked: {
                    dialog.hide()
                }
            }
        }
    }
}
