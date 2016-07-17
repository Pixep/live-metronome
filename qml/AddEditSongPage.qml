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
            userSettings.setSong(songIndex, titleEdit.text, artistEdit.text, parseInt(tempoEdit.text, 10))
        else
            userSettings.addSong(titleEdit.text, artistEdit.text, parseInt(tempoEdit.text, 10))

        hide()
    }

    function prefill()
    {
        var song = userSettings.songList[songIndex]
        titleEdit.text = song.title
        artistEdit.text = song.artist
        tempoEdit.text = "" + song.tempo
    }

    Column {
        anchors.fill: parent

        BaseText {
            text: "Title"
        }
        BaseEdit {
            id: titleEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
        }
        BaseText {
            text: "Artist"
        }
        BaseEdit {
            id: artistEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
        }
        BaseText {
            text: "Tempo"
        }
        BaseEdit {
            id: tempoEdit
            x: appStyle.width_col1
            width: appStyle.width_col5
            isNumber: true
        }
    }
}