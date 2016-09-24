import QtQuick 2.5
import QtQuick.Layouts 1.1

import "controls"
import "components"
import "dialogs"

ApplicationMenu {
    id: menu
    property Item lastMenuClicked

    Item {
        Layout.fillWidth: true
        height: appStyle.controlHeight

        BaseText {
            anchors.centerIn: parent
            text: gui.songsShown ? qsTr("Songs") : qsTr("Setlists")
            color: appStyle.textColor2
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: appStyle.backgroundColor2
        }
    }

    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        height: 2
    }

    MenuItem {
        id: selectSetlist
        text: qsTr("Setlists")
        iconSource: "qrc:/qml/images/icon_check.png"
        visible: gui.songsShown
        onClicked: {
            menu.close()
            gui.showSetlists()
        }
    }

    MenuItem {
        id: newSetlist
        text: qsTr("New setlist")
        iconSource: "qrc:/qml/images/icon_plus.png"
        visible: gui.setlistsShown
        onClicked: {
            menu.close()
            editDialog.show("Setlist name", newSetlist)
        }

        function onAccepted() {
            userSettings.addSetlist(editDialog.value)
            gui.showSongs()
        }
        function onRefused() {}
    }

    MenuItem {
        id: deleteSetlist
        text: qsTr("Delete setlist")
        iconSource: "qrc:/qml/images/icon_minus.png"
        visible: gui.setlistsShown
        onClicked: {
            lastMenuClicked = deleteSetlist
            menu.close()
            setlistDialog.show()
        }
    }

    Rectangle {
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        height: 2
    }

    MenuItem {
        id: editCurrentSong
        visible: gui.songsShown && metronome.isCurrentSongValid
        text: qsTr("Edit current song")
        iconSource: "qrc:/qml/images/icon_edit.png"
        iconScale: 0.8
        onClicked: {
            menu.close()
            controller.editSong(metronome.songIndex)
        }
    }

    Rectangle {
        visible: editCurrentSong
        Layout.fillWidth: true
        color: appStyle.backgroundColor2
        height: 2
    }

    MenuItem {
        text: qsTr("Add new song")
        iconSource: "qrc:/qml/images/icon_plus.png"
        visible: gui.songsShown
        onClicked: {
            menu.close()
            addEditPage.addNewSong()
        }
    }

    MenuItem {
        text: qsTr("Change songs order")
        visible: gui.songsShown && userSettings.songsModel.count >= 2
        iconSource: "qrc:/qml/images/icon_move.png"
        onClicked: {
            menu.close()
            moveSongsPage.show()
        }
    }

    MenuItem {
        id: clearAll
        text: qsTr("Clear all")
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
        text: qsTr("Reset all")
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
        iconSource: "qrc:/qml/images/icon_back.png"
        text: qsTr("Cancel")
        onClicked: {
            menu.close()
        }
    }

    ActionDialog {
        id: setlistDialog

        Repeater {
            id: setlistsRepeater
            model: userSettings.setlists

            ActionDialogItem {
                id: dialogItem
                text: {
                    if (index === userSettings.setlistIndex)
                        return "<b>" + modelData.name + "</b> " + qsTr("(current)")
                    else
                        return modelData.name
                }
                showSeparator: (index !== setlistsRepeater.count-1)
                onClicked: {
                    if (lastMenuClicked == selectSetlist)
                    {
                        userSettings.setCurrentSetlist(index);
                    }
                    else if (lastMenuClicked == deleteSetlist)
                    {
                        confirmDialog.show(qsTr("Do you confirm completly removing the setlist '%1' ?").arg(text),
                                           dialogItem)
                    }

                    setlistDialog.close()
                }

                function onAccepted() {
                    if (lastMenuClicked == deleteSetlist)
                        userSettings.removeSetlist(index)
                }
                function onRefused() {}
            }
        }

        resources: [
            Connections {
                target: contentRoot
                onBack: {
                    if (!setlistDialog.active)
                        return

                    setlistDialog.close()
                }
            }
        ]
    }
}
