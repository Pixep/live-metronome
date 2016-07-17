import QtQuick 2.5

ActionDialog {
    id: dialog

    signal updateSongTempo()
    signal editSong()
    signal removeSong()

    ActionDialogItem {
        text: qsTr("Update tempo")
        onClicked: {
            dialog.hide()
            dialog.updateSongTempo()
        }
    }
    ActionDialogItem {
        text: qsTr("Edit")
        onClicked: {
            dialog.hide()
            dialog.editSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Delete")
        onClicked: {
            dialog.hide()
            dialog.removeSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Cancel")
        showSeparator: false
        onClicked: {
            dialog.hide()
        }
    }
}
