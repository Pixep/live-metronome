import QtQuick 2.6

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
            color: "gray"
        }
        highlightMoveDuration: 300

        delegate: Item {
            width: parent.width
            height: 80

            Row {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    width: 0.2 * parent.width
                    height: parent.height
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                    text: index + "."
                }
                Text {
                    width: 0.6 * parent.width
                    height: parent.height
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                    text: modelData.title
                }
                Text {
                    width: 0.2 * parent.width
                    height: parent.height
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                    text: modelData.tempo + ""
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.songIndex = index
                }
                onPressAndHold: {
                    userSettings.songList[index].tempo = root.tempo
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
            height: parent.height * songListView.height / (songCount * 80)
            y: (songListView.contentY / (songCount * 80 - songListView.height)) * (parent.height - height)
        }
    }
}
