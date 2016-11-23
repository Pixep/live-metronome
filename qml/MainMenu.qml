import QtQuick 2.5
import QtQuick.Layouts 1.1

import "controls"
import "components"
import "dialogs"

ApplicationMenu {
    id: menu
    property Item lastMenuClicked

    signal newSetlist()
    signal renameSetlist()
    signal deleteSetlist()

    Item {
        Layout.fillWidth: true
        height: appStyle.controlHeight

        BaseText {
            id: title
            anchors.centerIn: parent
            text: gui.songsShown ? qsTr("Songs") : qsTr("Setlists") + application.trBind
            color: appStyle.textColor2
        }
    }

    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor
        height: 1
    }
    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        height: 1
    }

    MenuItem {
        id: selectSetlist
        text: qsTr("Setlists") + application.trBind
        iconSource: "qrc:/qml/images/icon_check.png"
        visible: gui.songsShown
        onClicked: {
            menu.close()
            gui.showSetlists()
        }
    }

    MenuItem {
        id: newSetlist
        text: qsTr("New setlist") + application.trBind
        iconSource: "qrc:/qml/images/icon_plus.png"
        visible: gui.setlistsShown
        onClicked: {
            menu.close()
            menu.newSetlist()
        }
    }

    MenuItem {
        id: renameSetlist
        text: qsTr("Rename setlist") + application.trBind
        iconSource: "qrc:/qml/images/icon_edit.png"
        iconScale: 0.8
        visible: gui.setlistsShown
        onClicked: {
            menu.close()
            menu.renameSetlist()
        }
    }

    MenuItem {
        id: deleteSetlist
        text: qsTr("Delete setlist") + application.trBind
        iconSource: "qrc:/qml/images/icon_minus.png"
        visible: gui.setlistsShown
        onClicked: {
            menu.close()
            menu.deleteSetlist()
        }
    }

    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor
        height: 1
    }
    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        height: 1
    }

    MenuItem {
        id: editCurrentSong
        visible: gui.songsShown && metronome.isCurrentSongValid
        text: qsTr("Edit current song") + application.trBind
        iconSource: "qrc:/qml/images/icon_edit.png"
        iconScale: 0.8
        onClicked: {
            menu.close()
            controller.editSong(metronome.songIndex)
        }
    }

    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor
        visible: editCurrentSong.visible
        height: 1
    }
    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        visible: editCurrentSong.visible
        height: 1
    }

    MenuItem {
        text: qsTr("Add new song") + application.trBind
        iconSource: "qrc:/qml/images/icon_plus.png"
        visible: gui.songsShown
        onClicked: {
            menu.close()
            addEditPage.addNewSong()
        }
    }

    MenuItem {
        text: qsTr("Change songs order") + application.trBind
        visible: gui.songsShown && userSettings.songsModel.count >= 2
        iconSource: "qrc:/qml/images/icon_move.png"
        onClicked: {
            menu.close()
            moveSongsPage.show()
        }
    }

    MenuItem {
        id: clearAll
        text: qsTr("Clear all") + application.trBind
        iconSource: "qrc:/qml/images/icon_clear.png"
        visible: gui.songsShown
        onClicked: {
            menu.close()
            confirmDialog.show(qsTr("Do you confirm removing all songs from the set ?"),
                               clearAll)
        }

        function onAccepted() {
            userSettings.removeAllSongs();
        }
        function onRefused() {
        }
    }

    MenuItem {
        id: resetAll
        visible: platform.isWindows
        text: qsTr("Reset all") + application.trBind
        onClicked: {
            menu.close()
            confirmDialog.show(qsTr("Do you confirm resetting all set content ?"),
                               resetAll)
        }

        function onAccepted() {
            userSettings.resetToDefault();
        }
        function onRefused() {
        }
    }

    MenuItem {
        id: settings
        text: qsTr("Settings") + application.trBind
        onClicked: {
            menu.close()
            settingsPage.show()
        }
    }

    MenuItem {
        iconSource: "qrc:/qml/images/icon_back.png"
        text: qsTr("Cancel") + application.trBind
        onClicked: {
            menu.close()
        }
    }
}
