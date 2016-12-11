import QtQuick 2.5

import "../../dialogs"

ActionDialog {
    id: dialog

    signal updateSongTempo()
    signal moveSong()
    signal editSong()
    signal removeSong()

    onVisibleChanged: {
        var song = userSettings.songsModel.get(contextValue);
        updateTempo.visible = song.tempo !== metronome.tempo
    }

    ActionDialogItem {
        id: updateTempo
        text: qsTr("Set tempo to %1").arg(metronome.tempo) + application.trBind
        height: visible ? appStyle.controlHeight : 0
        onClicked: {
            dialog.close()
            dialog.updateSongTempo()
        }
    }
    ActionDialogItem {
        text: qsTr("Edit") + application.trBind
        onClicked: {
            dialog.close()
            dialog.editSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Move song") + application.trBind
        onClicked: {
            dialog.close()
            dialog.moveSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Delete") + application.trBind
        onClicked: {
            dialog.close()
            dialog.removeSong()
        }
    }
    ActionDialogItem {
        text: qsTr("Cancel") + application.trBind
        showSeparator: false
        onClicked: {
            dialog.close()
        }
    }
}
