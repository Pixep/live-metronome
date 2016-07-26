import QtQuick 2.5
import QtQml.Models 2.2

Item {
    id: root
    width: parent.width
    height: 200

    property alias currentIndex: songListView.currentIndex

    signal editSong(var songIndex)

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
        //model: userSettings.songList
        model: DelegateModel {
            id: visualModel
            model: userSettings.songsModel
            /*ListModel {
                id: colorModel
                ListElement { color: "blue" }
                ListElement { color: "green" }
                ListElement { color: "red" }
                ListElement { color: "yellow" }
                ListElement { color: "orange" }
                ListElement { color: "purple" }
                ListElement { color: "cyan" }
                ListElement { color: "magenta" }
                ListElement { color: "chartreuse" }
                ListElement { color: "aquamarine" }
                ListElement { color: "indigo" }
                ListElement { color: "black" }
                ListElement { color: "lightsteelblue" }
                ListElement { color: "violet" }
                ListElement { color: "grey" }
                ListElement { color: "springgreen" }
                ListElement { color: "salmon" }
                ListElement { color: "blanchedalmond" }
                ListElement { color: "forestgreen" }
                ListElement { color: "pink" }
                ListElement { color: "navy" }
                ListElement { color: "goldenrod" }
                ListElement { color: "crimson" }
                ListElement { color: "teal" }
            }*/

            delegate: MouseArea {
                id: delegateRoot

                property int visualIndex: DelegateModel.itemsIndex

                width: songListView.width; height: 80
                drag.target: icon

                Rectangle {
                    id: icon
                    width: parent.width; height: 72
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }
                    //color: model.color
                    radius: 3

                    Drag.active: delegateRoot.drag.active
                    Drag.source: delegateRoot
                    Drag.hotSpot.x: 36
                    Drag.hotSpot.y: 36

                    Text {
                        anchors.fill: parent
                        text: "o" + title
                    }

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon;
                                anchors.horizontalCenter: undefined;
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }

                DropArea {
                    anchors { fill: parent; margins: 15 }

                    onEntered: visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                }
            }
        }

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

        //delegate: SongListDelegate{}
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
            userSettings.songList[contextValue].tempo = metronome.tempo
            userSettingsDb.save()
        }
        onMoveSong: {
            root.moveSong(contextValue)
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
