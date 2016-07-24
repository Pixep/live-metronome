import QtQuick 2.5

Item {
    id: root
    width: parent.width
    height: 200

    property alias currentIndex: songListView.currentIndex

    signal editSong(var songIndex)

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true
        model: userSettings.songList
        preferredHighlightBegin: appStyle.controlHeight
        preferredHighlightEnd: height - (2 * appStyle.controlHeight)
        highlightRangeMode: ListView.ApplyRange

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

        delegate: Item {
            width: parent.width
            height: appStyle.controlHeight

            Rectangle {
                color: appStyle.headerColor
                anchors.fill: parent
                opacity: songMouseArea.pressed ? 0.6 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 800
                        easing.type: Easing.OutQuad
                    }
                }
            }

            Row {
                anchors.fill: parent
                anchors.margins: appStyle.sidesMargin
                anchors.leftMargin: 2 * appStyle.sidesMargin
                scale: songMouseArea.pressed ? 0.9 : 1

                Behavior on scale {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

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
                id: songMouseArea
                anchors.fill: parent
                onPressed: {
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
            height: parent.height * songListView.height / (metronome.songCount * appStyle.controlHeight)
            y: (songListView.contentY / (metronome.songCount * appStyle.controlHeight - songListView.height)) * (parent.height - height)
        }
    }

    SongActionDialog {
        id: actionDialog
        parent: dialogContainer

        onUpdateSongTempo: {
            userSettings.songList[contextValue].tempo = metronome.tempo
            userSettingsDb.save()
        }
        onEditSong: {
            root.editSong(contextValue)
        }
        onRemoveSong: {
            confirmDialog.show(qsTr("Do you confirm removing '%1' ?").arg(userSettings.songList[contextValue].title),
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
