import QtQuick 2.5

import "../../dialogs"

ActionDialog {
    id: dialog

    signal updateSongTempo()
    signal moveSong()
    signal editSong()
    signal removeSong()

    ActionDialogItem {
        text: qsTr("Set tempo to %1").arg(metronome.tempo)
        visible: window.currentSongTempo != metronome.tempo
        height: visible ? appStyle.controlHeight : 0
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
        text: qsTr("Move song")
        onClicked: {
            dialog.close()
            dialog.moveSong()
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
