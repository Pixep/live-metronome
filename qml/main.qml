import QtQuick 2.5
import QtQuick.Window 2.2
import LiveMetronome 1.0
import QtMultimedia 5.5

import "pages"
import "dialogs"
import "components"
import "controls"

Window {
    id: window
    visible: true
    width: 480
    height: 800
    color: appStyle.backgroundColor

    readonly property alias appStyle: styleObject
    readonly property int currentSongTempo: mainPage.currentSongItem ? mainPage.currentSongItem.songTempo : -1
    readonly property bool isSongSelected: mainPage.currentSongItem

    Connections {
        target: userSettings
        onSettingsModified: {
            metronome.updateFromSong()
        }
    }

    Metronome {
        id: metronome

        property int songIndex: 0
        property int songCount: userSettings.songsModel.count

        onSongIndexChanged: {
            updateFromSong()
        }

        Component.onCompleted: {
            setTempo(tempo)
        }

        function updateFromSong()
        {
            if (songIndex >= 0 && songIndex < songCount)
            {
                mainPage.currentSongIndex = songIndex

                var song = userSettings.songsModel.get(songIndex)
                if (!song)
                    return

                metronome.setTempo(song.tempo)
                metronome.beatsPerMeasure = song.beatsPerMeasure
            }
        }

        function setTempo(value)
        {
            tempo = value
            mainPage.setTempo(value)
        }

        function nextSong()
        {
            songIndex = (songIndex + 1) % songCount
        }

        function previousSong()
        {
            if (songIndex <= 0)
                songIndex = songCount - 1
            else
                songIndex = songIndex - 1
        }
    }

    Connections {
        target: userSettings

        onSongAdded: {
            var temp = metronome.songIndex
            metronome.songIndex = 0
            metronome.songIndex = temp
        }
        onSongRemoved: {
            if (removedIndex < metronome.songIndex)
                metronome.songIndex--
            else if (removedIndex == metronome.songIndex)
                metronome.songIndex = 0
        }
        onAllSongsRemoved: {
           metronome.songIndex = 0
        }
    }

    QtObject {
        id: styleObject
        property int borderRadius: 5 * sizeFactor
        property int sidesMargin: 10 * sizeFactor
        property string textColor: "#f0f0f0"
        property string textColor2: "#c0c0c0"
        property string textColorDark: "#202020"
        property string headerColor: "#354582"
        property string headerColorDark: "#2a3251"
        property string backgroundColor: "#202020"
        property string backgroundColor2: "#656565"
        property string backgroundColor3: "#353535"
        property int baseFontSize: 30 * sizeFactor
        property int titleFontSize: 35 * sizeFactor
        property int smallFontSize: 20 * sizeFactor
        property int controlHeight: 80 * sizeFactor
        property int colMargin: sidesMargin
        property int width_col1: 1 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col2: 2 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col3: 3 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col4: 4 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col5: 5 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col6: pageContainer.width
        property real sizeFactor: {
            if (Screen.pixelDensity < 5)
                return 1
            if (Screen.pixelDensity < 10)
                return 1.22
            if (Screen.pixelDensity > 10)
                return 1.4
        }
    }

    UserSettings {
        id: userSettingsDb
        Component.onCompleted: {
            load()
        }

        onLoaded: {
            metronome.songIndex = 0
            metronome.updateFromSong()
        }
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true

        Keys.onBackPressed: {
            onBack()
        }

        signal back()

        function onBack() {
            if (addEditPage.visible)
                addEditPage.hide()
            else if (confirmDialog.visible)
                confirmDialog.close(false)
            else if (actionDialog.visible)
                actionDialog.close()

            back()
        }

        ApplicationHeader {
            id: appHeader
            backVisible: addEditPage.visible || moveSongsPage.visible
            menuVisible: !addEditPage.visible && !moveSongsPage.visible
            menuEnabled: !metronome.playing

            onBack: {
                contentRoot.onBack()
            }
            onShowMenu: {
                actionDialog.show()
            }
        }

        Item {
            id: pageContainer
            x: appStyle.sidesMargin
            width: parent.width - 2 * appStyle.sidesMargin
            anchors.top: appHeader.bottom
            anchors.bottom: parent.bottom

            property int backgroundWidth: parent.width
            property int backgroundHeight: height

            MainPage {
                id: mainPage
            }
            MoveSongsPage {
                id: moveSongsPage
            }
            AddEditSongPage {
                id: addEditPage
            }
        }

        Item {
            id: dialogContainer
            anchors.fill: parent
            z: 100

            ConfirmDialog {
                id: confirmDialog
            }

            ActionDialog {
                id: actionDialog

                ActionDialogItem {
                    text: qsTr("Add new song")
                    onClicked: {
                        actionDialog.close()
                        addEditPage.songIndex = -1;
                        addEditPage.clear()
                        addEditPage.show()
                        addEditPage.focusFirstField()
                    }
                }

                ActionDialogItem {
                    text: qsTr("Edit set order")
                    onClicked: {
                        actionDialog.close()
                        moveSongsPage.show()
                    }
                }

                ActionDialogItem {
                    text: qsTr("Clear all")
                    onClicked: {
                        actionDialog.close()
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

                Loader {
                    height: active ? appStyle.controlHeight : 0
                    width: parent.width
                    sourceComponent: resetAllAction
                    active: platform.isWindows

                    Component {
                        id: resetAllAction

                        ActionDialogItem {
                            text: qsTr("Reset all")
                            onClicked: {
                                actionDialog.close()
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
                    }
                }

                ActionDialogItem {
                    text: qsTr("Cancel")
                    showSeparator: false
                    onClicked: {
                        actionDialog.close()
                    }
                }
            }
        }
    }
}
