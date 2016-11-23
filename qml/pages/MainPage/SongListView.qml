import QtQuick 2.5
import QtQml.Models 2.2

import "../../controls"
import "../../dialogs"

Item {
    id: root
    width: parent.width
    height: 200

    property alias currentIndex: songListView.currentIndex
    property alias currentItem: songListView.currentItem

    BaseText {
        anchors.fill: songListView
        anchors.margins: appStyle.margin
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("No song present your set<br>Add one with the %1 button").arg("<img src='qrc:/qml/images/icon_menu.png'></img>") + application.trBind
        wrapMode: Text.WordWrap
        visible: !songListView.visible
    }

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true
        boundsBehavior: Flickable.OvershootBounds

        model: userSettings.songsModel
        delegate: SongListDelegate {
            titleText: title
            artistText: artist
            onClicked: {
                metronome.songIndex = index
            }
            onPressAndHold: {
                actionDialog.show(index)
            }
        }
        /*footer: SongListDelegate {
            id: addNewSongDelegate
            titleText: qsTr("Add new song")
            showNumber: false
            onClicked: {
                addEditPage.addNewSong()
            }
            onPressAndHold: {
                addEditPage.addNewSong()
            }

            Rectangle {
                width: parent.width
                height: width
                radius: width/2
                color:  appStyle.backgroundColor2
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -0.2*width
                parent: addNewSongDelegate.songNumberItem
                Image {
                    anchors.fill: parent
                    source: "qrc:/qml/images/icon_plus.png"
                }
            }
        }*/

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
}
