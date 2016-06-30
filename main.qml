import QtQuick 2.6
import QtQuick.Window 2.2
import QtMultimedia 5.6
import QtQuick.Layouts 1.1

Window {
    id: root
    visible: true
    width: 480
    height: 800

    property bool playing: false
    property int tempo: 120
    property int tickIndex: 0
    property int tickCount: 0
    property int songIndex: 0
    property int songCount: userSettings.songList.length

    onPlayingChanged: {
        if (! playing ) {
            tickIndex = 0
            tickCount = 0
        }
    }

    onSongIndexChanged: {
        if (songIndex >= 0 && songIndex < songCount)
        {
            tickIndex = 0
            tickCount = 0
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

    TempoControls {
        id: tempoControls

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
        onClicked: {
            root.playing = !root.playing
        }
    }

    Audio {
        id: tickHigh
        source: platform.soundsPath + "click_analog_high.wav"
    }

    SoundEffect {
        id: tickLow
        source: platform.soundsPath + "click_analog_low.wav"
    }

    Audio {
        id: tickLowAudio
        source: platform.soundsPath + "click_analog_low.wav"
        autoLoad: true
        onErrorChanged: {
            console.log("Error:" + errorString)
        }
        onSourceChanged: {
            console.log(source)
        }
    }

    Timer {
        id: metronomeTimer
        interval: 1000 * 60 / root.tempo
        repeat: true
        running: root.playing
        triggeredOnStart: true
        onTriggered: {
            if (root.tickIndex == 0)
                tickHigh.play()
            else
                tickLowAudio.play()

            root.tickCount++
            root.tickIndex = (root.tickIndex + 1) % 4
        }
    }
}
