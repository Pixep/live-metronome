import QtQuick 2.0

Page {
    id: page
    actionButtonsVisible: true

    property int songIndex
    readonly property  bool addingNewSong: songIndex < 0

    // Cancel
    onActionButtonLeftClicked: {
        hide()
    }

    // Save
    onActionButtonRightClicked: {
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
        beatsPerMeasureEdit.text = ""
    }

    function focusFirstField()
    {
        titleEdit.focus = true
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
        }
    }
}
