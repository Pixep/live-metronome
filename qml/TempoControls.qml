import QtQuick 2.5
import QtQuick.Layouts 1.1

RowLayout {
    id: root
    height: appStyle.controlHeight
    width: parent.width

    readonly property alias tempo: tempoTextItem.tempo

    signal decreaseTempo()
    signal decreaseTempoLarge()
    signal increaseTempo()
    signal increaseTempoLarge()

    onDecreaseTempo: setTempo(tempo - 1)
    onDecreaseTempoLarge: setTempo(tempo - 10)
    onIncreaseTempo: setTempo(tempo + 1)
    onIncreaseTempoLarge: setTempo(tempo + 10)

    function setTempo(newTempo) {
        if (newTempo < metronome.minTempo)
            newTempo = metronome.minTempo
        else if (newTempo > metronome.maxTempo)
            newTempo = metronome.maxTempo

        tempoTextItem.tempo = newTempo
    }

    Button {
        height: parent.height
        Layout.fillWidth: true
        imageSource: "qrc:/qml/images/icon_minus.png"
        onClicked: parent.decreaseTempo()
        onPressAndHold: decreaseButtonHoldTimer.start()
        onReleased: decreaseButtonHoldTimer.stop()

        Timer {
            id: decreaseButtonHoldTimer
            interval: 300
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                root.decreaseTempoLarge()
            }
        }
    }

    Item {
        height: parent.height
        Layout.fillWidth: true

        TextInput {
            id: tempoTextItem
            font.pixelSize: appStyle.titleFontSize
            color: appStyle.textColor
            anchors.centerIn: parent
            inputMethodHints: Qt.ImhDigitsOnly

            property int tempo

            onTempoChanged: {
                text = tempo.toString()
            }

            onTextChanged: {
                 if (text === "" || !isFinite(text))
                     return

                 var newTempo = parseInt(tempoTextItem.text, 10)
                 if (newTempo < metronome.minTempo || newTempo > metronome.maxTempo)
                     return

                 tempo = newTempo
            }
            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                {
                    event.accepted = true
                    contentRoot.focus = true
                }
            }
            onFocusChanged: {
                if (!focus)
                    validate()
            }

            function validate() {
                if (text === "" || !isFinite(text))
                {
                    text = tempo.toString()
                    return
                }

                var newTempo = parseInt(tempoTextItem.text, 10)
                if (newTempo < metronome.minTempo)
                {
                    tempo = metronome.minTempo
                    return
                }

                if (newTempo > metronome.maxTempo)
                {
                    tempo = metronome.maxTempo
                    return
                }
            }
        }
    }

    Button {
        height: parent.height
        Layout.fillWidth: true
        imageSource: "qrc:/qml/images/icon_plus.png"
        onClicked: root.increaseTempo()
        onPressAndHold: increaseButtonHoldTimer.start()
        onReleased: increaseButtonHoldTimer.stop()

        Timer {
            id: increaseButtonHoldTimer
            interval: 300
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                root.increaseTempoLarge()
            }
        }
    }
}
