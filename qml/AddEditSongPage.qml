import QtQuick 2.0

Page {
    actionButtonsVisible: true

    property int songIndex

    // Cancel
    onActionButtonLeftClicked: {
        hide()
    }

    // Save
    onActionButtonRightClicked: {
        if (songIndex >= 0)
            userSettings.setSong(songIndex, titleEdit.text, artistEdit.text,
                                 parseInt(tempoEdit.text, 10),
                                 parseInt(beatsPerMeasureEdit.text, 10))
        else
            userSettings.addSong(titleEdit.text, artistEdit.text,
                                 parseInt(tempoEdit.text, 10),
                                 parseInt(beatsPerMeasureEdit.text, 10))

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
        var song = userSettings.songList[songIndex]
        titleEdit.text = ""
        artistEdit.text = ""
        tempoEdit.text = ""
        beatsPerMeasureEdit.text = ""
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
            KeyNavigation.tab: artistEdit
        }
        BaseText {
            text: qsTr("Artist")
        }
        BaseEdit {
            id: artistEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            KeyNavigation.backtab: titleEdit
            KeyNavigation.tab: tempoEdit
        }
        BaseText {
            text: qsTr("Tempo")
        }
        BaseEdit {
            id: tempoEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            KeyNavigation.backtab: artistEdit
        }
        BaseText {
            text: qsTr("Beats per measure")
        }
        BaseEdit {
            id: beatsPerMeasureEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
            KeyNavigation.backtab: artistEdit
        }
    }
}
