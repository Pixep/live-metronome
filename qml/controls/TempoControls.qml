import QtQuick 2.5

Row {
    id: root
    height: appStyle.controlHeight
    spacing: appStyle.sidesMargin

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
        width: parent.width / 3 - 2/3 * appStyle.sidesMargin
        iconSource: "qrc:/qml/images/icon_minus.png"
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
        id: tempoTextElement
        height: parent.height
        width: parent.width / 3 - 2/3 * appStyle.sidesMargin

        Item {
            visible: tempoTextItem.focus
            x: -tempoTextElement.x - appStyle.sidesMargin
            y: parent.height + appStyle.sidesMargin
            width: root.width + appStyle.sidesMargin * 2
            height: window.height

            Rectangle {
                anchors.fill: parent
                color: appStyle.backgroundColor
                opacity: 0.9

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        contentRoot.resetFocus()
                    }
                }
            }

            Button {
                width: tempoTextElement.width
                height: appStyle.controlHeight
                text: qsTr("Tap tempo")
                textItem.wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter

                property double tapTime1: 0
                property double tapTime2: 0

                onButtonPressed: {
                    var currentTime = new Date().getTime()
                    if (currentTime - tapTime1 > 2000)
                    {
                        tapTime1 = 0;
                        tapTime2 = 0;
                    }

                    if(tapTime1 == 0) {
                        tapTime1 = currentTime
                    } else {
                        var delta1 = currentTime - tapTime1
                        var delta2 = tapTime1 - tapTime2

                        var deltaTime = 0.01
                        if (tapTime2 != 0 && delta1 > 0.8 * delta2 && delta1 < 1.2 * delta2)
                            deltaTime = (delta1+delta2)/2;
                        else
                            deltaTime = delta1

                        tapTime2 = tapTime1;
                        tapTime1 = currentTime

                        tempoTextItem.text = Math.round(60 * 1000 / deltaTime).toString()
                    }
                }
            }
        }

        Button {
            anchors.fill: parent
            onClicked: {
                tempoTextItem.enabled = true
                tempoTextItem.focus = true
            }

            Rectangle {
                color: appStyle.backgroundColor
                anchors.fill: parent
                anchors.margins: appStyle.sidesMargin / 2
                radius: appStyle.borderRadius
                visible: tempoTextItem.focus
            }

            TextInput {
                id: tempoTextItem
                enabled: focus
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: appStyle.titleFontSize
                color: appStyle.textColor
                inputMethodHints: Qt.ImhDigitsOnly

                property int tempo
                property int previousTempo

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
                    if (focus)
                    {
                        previousTempo = tempo
                        text = ""
                    }
                    else
                    {
                        validate()
                        enabled = false
                    }
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

                Connections {
                    target: contentRoot
                    onBack: {
                        if (!tempoTextItem.focus)
                            return

                        contentRoot.resetFocus()
                        tempoTextItem.tempo = tempoTextItem.previousTempo
                    }
                }
            }
        }
    }

    Button {
        height: parent.height
        width: parent.width / 3 - 2/3 * appStyle.sidesMargin
        iconSource: "qrc:/qml/images/icon_plus.png"
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
