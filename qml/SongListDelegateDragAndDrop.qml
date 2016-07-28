import QtQuick 2.5

MouseArea {
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

        Drag.onActiveChanged: {
            if (!Drag.active)
                userSettings.moveSong(index, delegateRoot.visualIndex)
        }

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

        onEntered: {
            visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
        }
    }
}
