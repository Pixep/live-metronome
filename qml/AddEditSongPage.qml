import QtQuick 2.5

Page {
    id: page
    actionButtonsVisible: true
    actionButtonRight.enabled: inputValid()

    property int songIndex
    readonly property  bool addingNewSong: songIndex < 0

    function inputValid()
    {
        return titleEdit.inputValid && artistEdit.inputValid
                && tempoEdit.inputValid && beatsPerMeasureEdit.inputValid
    }

    // Cancel
    onActionButtonLeftClicked: {
        hide()
    }

    // Save
    onActionButtonRightClicked: {
        titleEdit.validate()
        artistEdit.validate()
        tempoEdit.validate()
        beatsPerMeasureEdit.validate()

        if ( ! inputValid())
            return

        if (addingNewSong) {
            userSettings.addSong(titleEdit.text, artistEdit.text,
                                 parseInt(tempoEdit.text, 10),
                                 parseInt(beatsPerMeasureEdit.text, 10))
        }
        else {
            userSettings.setSong(songIndex, titleEdit.text, artistEdit.text,
                                 parseInt(tempoEdit.text, 10),
                                 parseInt(beatsPerMeasureEdit.text, 10))
        }

        hide()
    }

    function prefill()
    {
        var song = userSettings.songList[songIndex]
        titleEdit.text = song.title
        artistEdit.text = song.artist
        tempoEdit.text = "" + song.tempo
        beatsPerMeasureEdit.text = "" + song.beatsPerMeasure
    }

    function clear()
    {
        titleEdit.text = ""
        artistEdit.text = ""
        tempoEdit.text = ""
        beatsPerMeasureEdit.text = "4"

        titleEdit.inputValid = true
        artistEdit.inputValid = true
        tempoEdit.inputValid = true
        beatsPerMeasureEdit.inputValid = true
    }

    function focusFirstField()
    {
        titleEdit.forceActiveFocus()
    }

    Column {
        anchors.fill: parent

        BaseText {
            text: qsTr("Title")
        }
        BaseEdit {
            id: titleEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            nextFocused: artistEdit
            focusNextOnEnter: page.addingNewSong
            onValidateInput: {
                if (text !== "")
                    inputValid = true
                else
                    inputValid = false
            }
        }
        BaseText {
            text: qsTr("Artist")
        }
        BaseEdit {
            id: artistEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            previousFocused: titleEdit
            nextFocused: tempoEdit
            focusNextOnEnter: page.addingNewSong
        }
        BaseText {
            text: qsTr("Tempo")
        }
        BaseEdit {
            id: tempoEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            previousFocused: artistEdit
            nextFocused: beatsPerMeasureEdit
            focusNextOnEnter: page.addingNewSong
            onValidateInput: {
                if (text === "" || parseInt(text, 10) < metronome.minTempo
                        || parseInt(text, 10) > metronome.maxTempo)
                    inputValid = false
                else
                    inputValid = true
            }
        }
        BaseText {
            text: qsTr("Beats per measure")
        }
        BaseEdit {
            id: beatsPerMeasureEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            previousFocused: tempoEdit
            focusNextOnEnter: page.addingNewSong
            onValidateInput: {
                if (text === "" || !isFinite(text, 10))
                {
                    inputValid = false
                    return
                }

                if (parseInt(text, 10) < metronome.minBeatsPerMeasure
                        || parseInt(text, 10) > metronome.maxBeatsPerMeasure)
                {
                    inputValid = false
                    return
                }

                inputValid = true
            }
        }
    }
}
