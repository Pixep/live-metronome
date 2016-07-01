import QtQuick 2.5
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
    property alias appStyle: styleObject

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
        id: styleObject
        property int borderRadius: 5
        property int sidesMargin: 10
        property string textColor: "#f0f0f0"
        property string textColor2: "#c0c0c0"
        property string backgroundColor: "#333"
        property int baseFontSize: 30
        property int smallFontSize: 20
    }

    /*ApplicationHeader {
        id: appHeader
    }*/

    TempoControls {
        id: tempoControls
        //anchors.top: appHeader.bottom

        onTempoChanged: {
           root.tempo = tempo
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
            root.previousSong()
        }
        onNext: {
            root.nextSong()
        }
    }

    StartStopButton {
        id: startStopButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: appStyle.sidesMargin
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
