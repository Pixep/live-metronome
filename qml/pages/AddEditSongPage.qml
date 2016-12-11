import QtQuick 2.5

import "../components"
import "../controls"

Page {
    id: page
    y: page.bottomY / 4
    saveButtonsVisible: true
    actionButtonRight.enabled: inputValid()
    showAnimation: newShowAnimation
    hideAnimation: newHideAnimation

    property int songIndex
    property bool lastFieldReached: false
    readonly property bool addingNewSong: songIndex < 0
    readonly property bool focusNextOnEnter: addingNewSong && !lastFieldReached

    function addNewSong()
    {
        songIndex = -1;
        clear()
        show()
        focusFirstField()
    }

    function inputValid()
    {
        return titleEdit.inputValid && artistEdit.inputValid
                && tempoEdit.inputValid && beatsPerMeasureEdit.inputValid
    }

    onActiveChanged: {
        if (active)
            lastFieldReached = false
    }

    // Cancel
    onDiscard: {
        metronome.songIndex = songIndex
        hide()
    }

    // Save
    onSave: {
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
            metronome.songIndex = metronome.songCount-1
        }
        else {
            userSettings.setSong(songIndex, titleEdit.text, artistEdit.text,
                                 parseInt(tempoEdit.text, 10),
                                 parseInt(beatsPerMeasureEdit.text, 10))
            metronome.songIndex = songIndex
        }

        hide()
    }

    function prefill()
    {
        var song = userSettings.songsModel.get(songIndex)
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

    resources: [
        ParallelAnimation {
            id: newShowAnimation

            NumberAnimation {
                target: page
                property: "y"
                easing.overshoot: 1.200
                to: page.topY
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                target: page
                property: "opacity"
                to: 1
                duration: 300
                easing.type: Easing.OutCubic
            }
        },

        SequentialAnimation {
            id: newHideAnimation

            ParallelAnimation {
                PropertyAnimation {
                    target: page
                    property: "y"
                    to: window.height / 4
                    duration: 300
                    easing.type: Easing.OutCubic
                }
                PropertyAnimation {
                    target: page
                    property: "opacity"
                    to: 0
                    duration: 200
                    easing.type: Easing.Linear
                }
            }
            PropertyAction {
                target: page
                property: "visible"
                value: false
            }
        }
    ]

    Column {
        anchors.fill: parent

        BaseText {
            text: qsTr("Title") + application.trBind
        }
        BaseEdit {
            id: titleEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            nextFocused: artistEdit
            focusNextOnEnter: page.focusNextOnEnter
            onValidateInput: {
                if (text !== "")
                    inputValid = true
                else
                    inputValid = false
            }
        }
        BaseText {
            text: qsTr("Artist") + application.trBind
        }
        BaseEdit {
            id: artistEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            previousFocused: titleEdit
            nextFocused: tempoEdit
            focusNextOnEnter: page.focusNextOnEnter
        }
        BaseText {
            text: qsTr("Tempo") + application.trBind
        }
        BaseEdit {
            id: tempoEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            previousFocused: artistEdit
            nextFocused: beatsPerMeasureEdit
            onValidateInput: {
                if (text === "" || !isFinite(text))
                {
                    inputValid = false
                    return
                }

                if (parseInt(text, 10) < metronome.minTempo
                        || parseInt(text, 10) > metronome.maxTempo)
                {
                    inputValid = false
                    return
                }

                inputValid = true
            }
            onFocusChanged: {
                if (focus)
                    lastFieldReached = true
            }
        }
        BaseText {
            text: qsTr("Beats per measure") + application.trBind
        }
        BaseEdit {
            id: beatsPerMeasureEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            previousFocused: tempoEdit
            onValidateInput: {
                if (text === "" || !isFinite(text))
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
