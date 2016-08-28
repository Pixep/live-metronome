import QtQuick 2.5
import QtQuick.Layouts 1.1

import "controls"
import "components"

ApplicationMenu {
    id: menu

    Item {
        Layout.fillWidth: true
        height: appStyle.controlHeight

        BaseText {
            anchors.centerIn: parent
            text: "Live Metronome"
            color: appStyle.textColor2
        }

        Rectangle {
            id: separator
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: appStyle.backgroundColor2
        }
    }

    MenuItem {
        visible: metronome.isCurrentSongValid
        text: qsTr("Edit song")
        onClicked: {
            menu.close()
            controller.editSong(metronome.songIndex)
        }
    }

    MenuItem {
        text: qsTr("Add new song")
        onClicked: {
            menu.close()
            addEditPage.songIndex = -1;
            addEditPage.clear()
            addEditPage.show()
            addEditPage.focusFirstField()
        }
    }

    MenuItem {
        text: qsTr("Change songs order")
        visible: userSettings.songsModel.count >= 2
        onClicked: {
            menu.close()
            moveSongsPage.show()
        }
    }

    MenuItem {
        text: qsTr("Clear all")
        onClicked: {
            menu.close()
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

    MenuItem {
        visible: platform.isWindows
        text: qsTr("Reset all")
        onClicked: {
            menu.close()
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

    MenuItem {
        text: qsTr("Cancel")
        onClicked: {
            menu.close()
        }
    }
}
