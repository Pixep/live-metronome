import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: root
    visible: true
    width: 480
    height: 800
    color: "#333"

    property bool playing: false
    property int tempo: 80
    property int songIndex: 0
    property int songCount: userSettings.songList.length

    onSongIndexChanged: {
        if (songIndex >= 0 && songIndex < songCount)
        {
            clickSound.restart()
            setTempo(userSettings.songList[songIndex].tempo)
            songListView.currentIndex = songIndex
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

    QtObject {
        id: style
        property string textColor: "#f0f0f0"
        property string backgroundColor: "#333"
        property int baseFontSize: 24
    }

    ApplicationHeader {
        id: appHeader
    }

    TempoControls {
        id: tempoControls
        anchors.top: appHeader.bottom

        onTempoChanged: {
           root.tempo = tempo
        }
    }

    SongListView {
        id: songListView
        anchors.top: tempoControls.bottom
        anchors.bottom: previousNextRow.top
    }

    PreviousNextControls {
        id: previousNextRow
        anchors.bottom: startStopButton.top
        anchors.bottomMargin: 10

        onPrevious: {
            root.previousSong()
        }
        onNext: {
            root.nextSong()
        }
    }

    StartStopButton {
        id: startStopButton
        anchors.bottom: parent.bottom
        playing: root.playing
        tickIndex: clickSound.tickIndex

        onClicked: {
            root.playing = !root.playing
        }
    }

    ClickSound {
        id: clickSound
        tempo: root.tempo
        playing: root.playing
    }
}
