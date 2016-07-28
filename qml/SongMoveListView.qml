import QtQuick 2.5
import QtQml.Models 2.2

Item {
    id: root
    width: parent.width
    height: 200

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true

        model: DelegateModel {
            id: visualModel
            model: userSettings.songsModel

            delegate: SongListDelegateDragAndDrop {}
        }
    }
}
