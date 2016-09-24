import QtQuick 2.5
import QtQml.Models 2.2

import "../../controls"
import "../../dialogs"
import "../../pages/MainPage"

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
        text: qsTr("No song present your set<br>Add one with the %1 button").arg("<img src='qrc:/qml/images/icon_menu.png'></img>")
        wrapMode: Text.WordWrap
        visible: !songListView.visible
    }

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true
        boundsBehavior: Flickable.OvershootBounds

        model: userSettings.setlists
        delegate: SetlistDelegate {
            nameText: modelData.name
            subtitleText: modelData.count === 0 ? qsTr("emtpy") : qsTr("%n song(s)", "", modelData.count)
            onClicked: {
                userSettings.setCurrentSetlist(index)
                gui.showSongs()
            }
        }

        footer: SongListDelegate {
            id: addNewSongDelegate
            titleText: qsTr("Add setlist")
            visible: application.allowPlaylists
            showNumber: false
            onClicked: {
                //addEditPage.addNewSong()
            }
            onPressAndHold: {
                //addEditPage.addNewSong()
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
}
