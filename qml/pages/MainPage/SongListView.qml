import QtQuick 2.5
import QtQml.Models 2.2

import "../../controls"
import "../../dialogs"

Item {
    id: root
    width: parent.width
    height: 200

    property alias currentIndex: songListView.currentIndex

    signal editSong(var songIndex)

    onCurrentIndexChanged: {
        var song = songListView.model.get(currentIndex)

        metronome.setTempo(song.tempo)
        metronome.beatsPerMeasure = songListView.model.get(currentIndex).beatsPerMeasure
    }

    BaseText {
        anchors.fill: songListView
        anchors.margins: appStyle.sidesMargin
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("No song present your set<br>Add one with the <img src='qrc:/qml/images/icon_menu.png'></img> button")
        wrapMode: Text.WordWrap
        visible: !songListView.visible
    }

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true

        model: userSettings.songsModel
        delegate: SongListDelegate {}

        preferredHighlightBegin: appStyle.controlHeight
        preferredHighlightEnd: height - (2 * appStyle.controlHeight)
        highlightRangeMode: ListView.ApplyRange
        visible: count > 0

        highlight: Rectangle {
            width: songListView.width
            height: appStyle.controlHeight
            color: appStyle.backgroundColor2

            Image {
                y: 0.15 * parent.height
                height: 0.7 * parent.height
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: "qrc:/qml/images/track_indicator.png"
                horizontalAlignment: Image.AlignLeft
            }
        }
        highlightMoveDuration: 300
    }

    Item {
        id: songScrollBar
        anchors.top: songListView.top
        anchors.right: parent.right
        height: songListView.height
        width: 10
        clip: true
        visible: scroll.height < height

        Rectangle {
            id: scroll
            width: parent.width
            color: "gray"
            height: parent.height * songListView.height / (metronome.songCount * appStyle.controlHeight)
            y: (songListView.contentY / (metronome.songCount * appStyle.controlHeight - songListView.height)) * (parent.height - height)
        }
    }

    Connections {
        target: contentRoot
        onBack: {
           actionDialog.close()
        }
    }

    SongActionDialog {
        id: actionDialog
        parent: dialogContainer

        onUpdateSongTempo: {
            userSettings.songsModel[contextValue].tempo = metronome.tempo
            userSettingsDb.save()
        }
        onMoveSong: {
            root.moveSong(contextValue)
        }
        onEditSong: {
            root.editSong(contextValue)
        }
        onRemoveSong: {
            confirmDialog.show(qsTr("Do you confirm removing '%1' ?").arg(userSettings.songsModel[contextValue].title),
                               removeConfirmation)
        }
    }

    QtObject {
        id: removeConfirmation
        function onAccepted() {
            userSettings.removeSong(actionDialog.contextValue)
        }
        function onRefused() {
            // Do nothing
        }
    }
}
