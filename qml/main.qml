import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: window
    visible: true
    width: 480
    height: 800
    color: appStyle.backgroundColor

    property alias appStyle: styleObject

    QtObject {
        id: metronome
        property bool playing: false
        property int tempo: 80
        property int songIndex: 0
        property int songCount: userSettings.songList.length

        onSongIndexChanged: {
            updateTempoFromSong()
        }

        function updateTempoFromSong()
        {
            if (songIndex >= 0 && songIndex < songCount)
            {
                setTempo(userSettings.songList[songIndex].tempo)
                songListView.currentIndex = songIndex
                clickSound.restart()
            }
        }

        function setTempo(value)
        {
            tempo = value
            tempoControls.setTempo(value)
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
        id: styleObject
        property int borderRadius: 5
        property int sidesMargin: 10
        property string textColor: "#f0f0f0"
        property string textColor2: "#c0c0c0"
        property string textColorDark: "#202020"
        property string headerColor: "#354582"
        property string backgroundColor: "#202020"
        property string backgroundColor2: "#656565"
        property int baseFontSize: 30
        property int titleFontSize: 35
        property int smallFontSize: 20
        property int controlHeight: 80
        property int colMargin: sidesMargin
        property int width_col1: 1 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col2: 2 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col3: 3 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col4: 4 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col5: 5 * pageContainer.width / 6 - 0.5*sidesMargin
        property int width_col6: pageContainer.width
    }

    UserSettings {
        id: userSettingsDb
        Component.onCompleted: {
            load()
        }

        onLoaded: {
            metronome.songIndex = 0
            metronome.updateTempoFromSong()
        }
    }

    ApplicationHeader {
        id: appHeader
    }

    Item {
        id: pageContainer
        x: appStyle.sidesMargin
        width: parent.width - 2 * appStyle.sidesMargin
        anchors.top: appHeader.bottom
        anchors.bottom: parent.bottom

        property int backgroundWidth: parent.width
        property int backgroundHeight: height

        Page {
            x: 0
            visible: true

            TempoControls {
                id: tempoControls

                onTempoChanged: {
                   metronome.tempo = tempo
                }
            }

            SongListView {
                id: songListView
                x: - appStyle.sidesMargin
                width: parent.width + 2 * appStyle.sidesMargin
                anchors.top: tempoControls.bottom
                anchors.topMargin: appStyle.sidesMargin
                anchors.bottom: previousNextRow.top
                anchors.bottomMargin: appStyle.sidesMargin

                onEditSong: {
                    addEditPage.songIndex = songIndex;
                    addEditPage.show()
                    addEditPage.prefill()
                }
            }

            PreviousNextControls {
                id: previousNextRow
                anchors.bottom: startStopButton.top
                anchors.bottomMargin: 10

                onPrevious: {
                    metronome.previousSong()
                }
                onNext: {
                    metronome.nextSong()
                }
            }

            StartStopButton {
                id: startStopButton
                anchors.bottom: parent.bottom
                playing: metronome.playing
                tickIndex: clickSound.tickIndex
                tickCount: clickSound.tickCount

                onClicked: {
                    metronome.playing = !metronome.playing
                }
            }

            ClickSound {
                id: clickSound
                tempo: metronome.tempo
                playing: metronome.playing
            }
        }

        AddEditSongPage {
            id: addEditPage
        }
    }

    ConfirmDialog {
        id: confirmDialog
    }
}