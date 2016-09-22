import QtQuick 2.5

import "../components"
import "../controls"
import "MainPage"

Page {
    id: page
    x: 0
    visible: true
    showAnimation: newShowAnimation
    hideAnimation: newHideAnimation

    property alias currentSongIndex: songListView.currentIndex
    readonly property alias currentSongItem: songListView.currentItem

    function setTempo(tempo)
    {
        tempoControls.setTempo(tempo)
    }

    resources: [
        SequentialAnimation {
            id: newShowAnimation
        },

        SequentialAnimation {
            id: newHideAnimation
        }
    ]

    TempoControls {
        id: tempoControls
        width: parent.width
        z: 100

        onTempoChanged: {
           metronome.tempo = tempo
        }
    }

    SongListView {
        id: songListView
        x: - appStyle.margin
        width: parent.width + 2 * appStyle.margin
        anchors.top: tempoControls.bottom
        anchors.topMargin: appStyle.margin
        anchors.bottom: previousNextRow.top
        anchors.bottomMargin: appStyle.margin
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
        beatIndex: metronome.beatIndex
        beatTotalCount: metronome.beatTotalCount
        beatsPerMeasure: metronome.beatsPerMeasure

        onClicked: {
            metronome.playing = !metronome.playing
        }
    }

    SongActionDialog {
        id: actionDialog

        onUpdateSongTempo: {
            var song = userSettings.songsModel.get(contextValue);
            if (!song)
                return;

            userSettings.setSong(contextValue, song.title, song.artist, metronome.tempo, song.beatsPerMeasure)
            userSettingsDb.save()
        }
        onMoveSong: {
            moveSongsPage.show()
        }
        onEditSong: {
            controller.editSong(contextValue)
        }
        onRemoveSong: {
            confirmDialog.show(qsTr("Do you confirm removing '%1' ?").arg(userSettings.songsModel.get(contextValue).title),
                               removeConfirmation)
        }

        resources: [
            QtObject {
                id: removeConfirmation
                function onAccepted() {
                    userSettings.removeSong(actionDialog.contextValue)
                }
                function onRefused() {
                    // Do nothing
                }
            },
            Connections {
                target: contentRoot
                onBack: {
                    if (!actionDialog.active)
                        return

                    actionDialog.close()
                }
            }
        ]
    }
}
