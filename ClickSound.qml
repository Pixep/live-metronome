import QtQuick 2.5
import QtMultimedia 5.5

Item {
    id: root
    property bool playing: false
    property int tickIndex: 0
    property int tickCount: 0
    property int tempo: 80

    onPlayingChanged: {
        if (! playing ) {
            restart()
        }
    }

    function restart()
    {
        tickIndex = 0
        tickCount = 0
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
            if (root.tickCount !== 0)
                root.tickIndex = (root.tickIndex + 1) % 4

            if (root.tickIndex == 0)
                tickHigh.play()
            else
                tickLowAudio.play()

            root.tickCount++
        }
    }
}
