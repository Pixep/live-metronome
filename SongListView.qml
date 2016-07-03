import QtQuick 2.5

Item {
    width: parent.width
    height: 200

    property alias currentIndex: songListView.currentIndex

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true
        model: userSettings.songList
        preferredHighlightBegin: 80
        preferredHighlightEnd: height - (2 * 80)
        highlightRangeMode: ListView.ApplyRange

        highlight: Rectangle {
            width: parent.width
            height: 80
            color: appStyle.backgroundColor2

            Image {
                y: 0.15 * parent.height
                height: 0.7 * parent.height
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/track_indicator.png"
                horizontalAlignment: Image.AlignLeft
            }
        }
        highlightMoveDuration: 300

        delegate: Item {
            width: parent.width
            height: 80

            Row {
                anchors.fill: parent
                anchors.margins: appStyle.sidesMargin
                anchors.leftMargin: 2 * appStyle.sidesMargin

                BaseText {
                    x: 0.15 * parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    text: (index+1) + "."
                }

                Item {
                    width: 0.05 * parent.width
                    height: parent.height
                }

                Item {
                    width: 0.65 * parent.width
                    height: parent.height

                    BaseText {
                        width: parent.width
                        height: parent.height
                        verticalAlignment: artistText.visible ? Text.AlignTop : Text.AlignVCenter
                        text: modelData.title
                        elide: Text.ElideRight
                    }

                    BaseText {
                        id: artistText
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignBottom
                        color: appStyle.textColor2
                        font.pixelSize: appStyle.smallFontSize
                        text: modelData.artist
                        elide: Text.ElideRight
                        visible: modelData.artist !== ""
                    }
                }

                BaseText {
                    width: 0.15 * parent.width
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData.tempo + ""
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    metronome.songIndex = index
                }
                onPressAndHold: {
                    actionDialog.show(index)
                }
            }
        }
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
            height: parent.height * songListView.height / (metronome.songCount * 80)
            y: (songListView.contentY / (metronome.songCount * 80 - songListView.height)) * (parent.height - height)
        }
    }

    SongActionDialog {
        id: actionDialog
        onUpdateSongTempo: {
            userSettings.songList[actionSongIndex].tempo = metronome.tempo
            userSettingsDb.save()
        }
        onEditSong: {

        }
        onRemoveSong: {
            userSettings.removeSong(actionSongIndex)
        }
    }
}
