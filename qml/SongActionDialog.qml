import QtQuick 2.5

ActionDialog {
    id: dialog

    signal updateSongTempo()
    signal editSong()
    signal removeSong()

    ActionDialogItem {
        text: qsTr("Update tempo")
        onClicked: {
            dialog.close()
            dialog.updateSongTempo()
        }
    }
    ActionDialogItem {
        text: qsTr("Edit")
        onClicked: {
            dialog.close()
            dialog.editSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Delete")
        onClicked: {
            dialog.close()
            dialog.removeSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Cancel")
        showSeparator: false
        onClicked: {
            dialog.close()
        }
    }
}
