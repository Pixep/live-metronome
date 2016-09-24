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

    Item {
        id: gui
        readonly property bool setlistsShown: p.currentPage == 0
        readonly property bool songsShown: p.currentPage == 1
        readonly property int currentPage: p.currentPage

        QtObject {
            id: p
            property int currentPage: 1
        }

        function showSetlists() {
            p.currentPage = 0
        }
        function showSongs() {
            p.currentPage = 1
        }
    }

    Metronome {
        id: metronome

        property int songIndex: 0
        property int songCount: userSettings.songsModel.count
        readonly property bool isCurrentSongValid: (songIndex >= 0 && songIndex < songCount)

        onSongIndexChanged: {
            updateFromSong()
        }

        Component.onCompleted: {
            setTempo(tempo)
        }

        function updateFromSong()
        {
            if (!isCurrentSongValid)
                return

            mainPage.currentSongIndex = songIndex

            var song = userSettings.songsModel.get(songIndex)
            if (!song)
                return

            metronome.setTempo(song.tempo)
            metronome.beatsPerMeasure = song.beatsPerMeasure
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

    QtObject {
        id: controller
        function editSong(songIndex) {
            addEditPage.songIndex = songIndex;
            addEditPage.prefill()
            addEditPage.show()
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

    ApplicationStyle {
        id: styleObject
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
        Keys.onEscapePressed: {
            if (platform.isWindows)
                onBack()
        }

        signal back()

        function onBack() {
            if (addEditPage.visible)
                addEditPage.hide()
            else if (confirmDialog.visible)
                confirmDialog.close(false)
            else if (mainMenu.visible)
                mainMenu.close()

            back()
        }

        function resetFocus() {
            contentRoot.focus = true
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
                mainMenu.show()
            }
        }

        Item {
            id: pageContainer
            x: appStyle.margin
            width: parent.width - 2 * appStyle.margin
            anchors.top: appHeader.bottom
            anchors.bottom: parent.bottom

            property int backgroundWidth: parent.width
            property int backgroundHeight: height

            Row {
                x: -gui.currentPage * (pageContainer.width + spacing)
                height: parent.height
                width: childrenRect.width
                spacing: 2 * appStyle.margin

                Behavior on x {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                Item {
                    height: parent.height
                    width: pageContainer.width

                    SetlistPage {
                        id: setlistPage
                    }
                }

                Item {
                    height: parent.height
                    width: pageContainer.width

                    MainPage {
                        id: mainPage
                    }
                }
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

            MainMenu {
                id: mainMenu
            }

            EditDialog {
                id: editDialog
            }

            Item {
                id: toast
                height: parent.height
                x: 0.1 * parent.width
                width: 0.8 * parent.width
                opacity: 0

                function show(text) {
                    toastText.text = text
                    enabled = true
                    opacity = 1
                    hideTimer.start()
                }

                Rectangle {
                    anchors.fill: toastText
                    anchors.margins: -appStyle.margin
                    radius: appStyle.borderRadius
                    color: "black"
                    opacity: 0.9

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideAnimation.start()
                            hideTimer.stop()
                        }
                    }
                }

                BaseText {
                    id: toastText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.Wrap
                }

                Timer {
                    id: hideTimer
                    interval: 2000
                    onTriggered: {
                        hideAnimation.start()
                            toast.enabled = false
                    }
                }

                SequentialAnimation {
                    id: hideAnimation
                    PropertyAction {
                        target: toast
                        property: "enabled"
                        value: false
                    }

                    NumberAnimation {
                        target: toast
                        property: "opacity"
                        to: 0
                        duration: 250
                    }
                }
            }
        }
    }
}
