import QtQuick 2.5

import "../components"
import "../controls"
import "SetlistPage"

Page {
    id: page
    x: 0
    visible: true

    function setTempo(tempo)
    {
        tempoControls.setTempo(tempo)
    }

    resources: [
        SequentialAnimation {
            id: newShowAnimation
        },

        SequentialAnimation {
            id: newHideAnimation
        }
    ]

    SetlistListView {
        id: songListView
        x: - appStyle.margin
        width: parent.width + 2 * appStyle.margin
        anchors.top: parent.top
        anchors.topMargin: appStyle.margin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: appStyle.margin
    }
}
