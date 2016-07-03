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
        property string headerColor: "#354582"
        property string backgroundColor: "#202020"
        property string backgroundColor2: "#656565"
        property int baseFontSize: 30
        property int titleFontSize: 35
        property int smallFontSize: 20
    }

    UserSettings {
        Component.onCompleted: {
            load()
        }
    }

    ApplicationHeader {
        id: appHeader
    }

    TempoControls {
        id: tempoControls
        anchors.top: appHeader.bottom
        anchors.topMargin: appStyle.sidesMargin * 2

        onTempoChanged: {
           metronome.tempo = tempo
        }
    }

    SongListView {
        id: songListView
        anchors.top: tempoControls.bottom
        anchors.topMargin: appStyle.sidesMargin
        anchors.bottom: previousNextRow.top
        anchors.bottomMargin: appStyle.sidesMargin
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
        anchors.bottomMargin: appStyle.sidesMargin
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
