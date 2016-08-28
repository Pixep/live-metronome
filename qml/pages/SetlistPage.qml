import QtQuick 2.5

import "../components"
import "../controls"
import "SetlistPage"

Page {
    id: page
    x: 0
    visible: true

    property alias currentSongIndex: songListView.currentIndex
    readonly property alias currentSongItem: songListView.currentItem

    function setTempo(tempo)
    {
        tempoControls.setTempo(tempo)
    }

    SetlistListView {
        id: songListView
        x: - appStyle.margin
        width: parent.width + 2 * appStyle.margin
        anchors.top: tempoControls.bottom
        anchors.topMargin: appStyle.margin
        anchors.bottom: previousNextRow.top
        anchors.bottomMargin: appStyle.margin
    }
}
