import QtQuick 2.5
import QtQml.Models 2.2

import "../../controls"

Item {
    id: root
    width: parent.width
    height: 200

    property bool dragging: false

    signal changeMade()

    ListView {
        id: songListView
        anchors.fill: parent
        cacheBuffer: Math.max(800, 3 * height)
        clip: true
        boundsBehavior: Flickable.OvershootBounds
        displaced: Transition {
            NumberAnimation {
                properties: "y";
                easing.type: Easing.OutBack
                duration: 300
            }
        }
        model: DelegateModel {
            id: visualModel
            model: userSettings.songsMoveModel

            delegate: Item {
                id: delegateRoot
                width: parent.width
                height: appStyle.controlHeight

                property int visualIndex: DelegateModel.itemsIndex

                MouseArea {
                    id: dragMouseArea
                    height: parent.height
                    width: handle.width
                    anchors.right: parent.right
                    drag.target: songItem

                    property alias visualIndex: delegateRoot.visualIndex
                }

                DropArea {
                    anchors { fill: parent; margins: 15 }

                    onEntered: {
                        visualModel.items.move(drag.source.visualIndex, dragMouseArea.visualIndex)
                    }
                }

                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: 1
                    border.color: appStyle.textColor
                    visible: dragMouseArea.visualIndex != 0
                }

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: 0.33
                    visible: dragMouseArea.drag.active
                }

                Item {
                    id: songItem
                    width: delegateRoot.width
                    height: delegateRoot.height
                    anchors.horizontalCenter: delegateRoot.horizontalCenter
                    anchors.verticalCenter: delegateRoot.verticalCenter

                    Drag.active: dragMouseArea.drag.active
                    Drag.source: dragMouseArea
                    Drag.hotSpot.x: width/2
                    Drag.hotSpot.y: height/2

                    Rectangle {
                        color: appStyle.headerColor
                        anchors.fill: parent
                        opacity: dragMouseArea.drag.active ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    Drag.onActiveChanged: {
                        root.dragging = Drag.active

                        if (!Drag.active)
                        {
                            userSettings.moveSong(index, dragMouseArea.visualIndex)
                            root.changeMade()
                        }
                    }

                    states: [
                        State {
                            when: songItem.Drag.active
                            ParentChange {
                                target: songItem
                                parent: root
                            }

                            AnchorChanges {
                                target: songItem;
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]

                    Row {
                        anchors.fill: parent
                        anchors.margins: appStyle.margin
                        anchors.leftMargin: 2 * appStyle.margin
                        scale: Drag.active ? 0.9 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutQuad
                            }
                        }

                        BaseText {
                            width: 0.10 * parent.width
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: (dragMouseArea.visualIndex+1) + "."
                        }

                        Item {
                            width: 0.70 * parent.width
                            height: parent.height

                            BaseText {
                                width: parent.width
                                height: parent.height
                                verticalAlignment: artistText.visible ? Text.AlignTop : Text.AlignVCenter
                                text: title
                                elide: Text.ElideRight
                            }

                            BaseText {
                                id: artistText
                                width: parent.width
                                height: parent.height
                                verticalAlignment: Text.AlignBottom
                                color: appStyle.textColor2
                                font.pixelSize: appStyle.smallFontSize
                                text: artist
                                elide: Text.ElideRight
                                visible: artist !== ""
                            }
                        }
                    }

                    Image {
                        id: handle
                        width: 0.25 * parent.width
                        height: parent.height
                        anchors.right: parent.right
                        source: "qrc:/qml/images/icon_handle.png"
                        fillMode: Image.PreserveAspectFit
                        visible: !root.dragging || dragMouseArea.drag.active
                    }
                }
            }
        }
    }
}
