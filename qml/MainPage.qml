import QtQuick 2.5

Page {
    x: 0
    visible: true

    property alias currentSongIndex: songListView.currentIndex

    function setTempo(tempo)
    {
        tempoControls.setTempo(tempo)
    }

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
            addEditPage.prefill()
            addEditPage.show()
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
        beatIndex: metronome.beatIndex
        beatTotalCount: metronome.beatTotalCount
        beatsPerMeasure: metronome.beatsPerMeasure

        onClicked: {
            metronome.playing = !metronome.playing
        }
    }
}
