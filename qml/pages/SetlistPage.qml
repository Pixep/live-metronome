import QtQuick 2.5

import "../components"
import "../controls"
import "../dialogs"
import "SetlistPage"

Page {
    id: page
    x: 0
    visible: true

    function newSetlist()
    {
        p.action = p._ActionNewSetlist
        editDialog.show(qsTr("Setlist name"), p)
    }
    function renameSetlist()
    {
        p.action = p._ActionRenameSetlist
        setlistDialog.show()
    }
    function deleteSetlist()
    {
        p.action = p._ActionDeleteSetlist
        setlistDialog.show()
    }

    resources: [
        SequentialAnimation {
            id: newShowAnimation
        },

        SequentialAnimation {
            id: newHideAnimation
        },

        Connections {
            target: contentRoot
            onBack: {
                if (!page.visible)
                    return

                gui.showSongs()
            }
        },

        QtObject {
            id: p

            property int action
            property int actionSetlistIndex
            readonly property int _ActionNewSetlist: 0
            readonly property int _ActionRenameSetlist: 1
            readonly property int _ActionDeleteSetlist: 2

            function renameSetlist(index, name) {
                action = _ActionRenameSetlist
                actionSetlistIndex = index
                editDialog.show(qsTr("Setlist name"), p)
            }
            function deleteSetlist(index, name) {
                action = _ActionDeleteSetlist
                actionSetlistIndex = index
                confirmDialog.show(qsTr("Do you confirm completly removing the setlist '%1' ?").arg(name),
                                   p)
            }

            function onAccepted() {
                if (action === _ActionNewSetlist) {
                    userSettings.addSetlist(editDialog.value)
                    gui.showSongs()
                }
                else if (action === _ActionRenameSetlist) {
                    userSettings.setSetlistName(actionSetlistIndex, editDialog.value)
                }
                else if (action === _ActionDeleteSetlist) {
                    userSettings.removeSetlist(actionSetlistIndex)
                }
            }
            function onRefused() {}
        }
    ]

    pageContent: [
        SetlistListView {
            id: songListView
            x: - appStyle.margin
            width: parent.width + 2 * appStyle.margin
            anchors.top: parent.top
            anchors.topMargin: appStyle.margin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: appStyle.margin

            onSetlistPressAndHold: {
                actionDialog.show(index, name)
            }
        },

        SetlistActionDialog {
            id: actionDialog

            onRenameSetlist: {
                p.renameSetlist(contextValue, contextValue2)
            }
            onDeleteSetlist: {
                p.deleteSetlist(contextValue, contextValue2)
            }

            resources: [
                Connections {
                    target: contentRoot
                    onBack: {
                        if (!actionDialog.active)
                            return

                        actionDialog.close()
                    }
                }
            ]
        },

        ActionDialog {
            id: setlistDialog

            Repeater {
                id: setlistsRepeater
                model: userSettings.setlists

                ActionDialogItem {
                    id: dialogItem
                    text: {
                        if (index === userSettings.setlistIndex)
                            return "<b>" + modelData.name + "</b> " + qsTr("(current)")
                        else
                            return modelData.name
                    }
                    showSeparator: (index !== setlistsRepeater.count-1)
                    onClicked: {
                        if (p.action === p._ActionRenameSetlist)
                            p.renameSetlist(index, text)
                        else if (p.action === p._ActionDeleteSetlist)
                            p.deleteSetlist(index, text)

                        setlistDialog.close()
                    }
                }
            }

            resources: [
                Connections {
                    target: contentRoot
                    onBack: {
                        if (!setlistDialog.active)
                            return

                        setlistDialog.close()
                    }
                }
            ]
        }
    ]
}
