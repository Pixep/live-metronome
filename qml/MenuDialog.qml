import QtQuick 2.5

import "dialogs"

ActionDialog {
    id: dialog

    ActionDialogItem {
        visible: metronome.isCurrentSongValid
        text: qsTr("Edit song")
        onClicked: {
            dialog.close()
            controller.editSong(metronome.songIndex)
        }
    }

    ActionDialogItem {
        text: qsTr("Add new song")
        onClicked: {
            dialog.close()
            addEditPage.songIndex = -1;
            addEditPage.clear()
            addEditPage.show()
            addEditPage.focusFirstField()
        }
    }

    ActionDialogItem {
        text: qsTr("Change songs order")
        onClicked: {
            dialog.close()
            moveSongsPage.show()
        }
    }

    ActionDialogItem {
        text: qsTr("Clear all")
        onClicked: {
            dialog.close()
            confirmDialog.show(qsTr("Do you confirm removing all songs from the set ?"),
                               clearConfirmation)
        }

        QtObject {
            id: clearConfirmation
            function onAccepted() {
                userSettings.removeAllSongs();
            }
            function onRefused() {
            }
        }
    }

    ActionDialogItem {
        visible: platform.isWindows
        text: qsTr("Reset all")
        onClicked: {
            dialog.close()
            confirmDialog.show(qsTr("Do you confirm resetting all set content ?"),
                               resetConfirmation)
        }

        QtObject {
            id: resetConfirmation
            function onAccepted() {
                userSettings.resetToDefault();
            }
            function onRefused() {
            }
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
