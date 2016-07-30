import QtQuick 2.5

import "../components"
import "../controls"
import "MoveSongsPage"

Page {
    id: page
    property bool changesMade

    function show() {
        userSettings.discardSongMoves()
        changesMade = false
        p.__show()
    }

    function saveChanges() {
        if (changesMade)
            userSettings.commitSongMoves()

        hide()
    }
    function discardChanges() {
        if (changesMade)
            userSettings.discardSongMoves()

        hide()
    }

    MoveSongListView {
        id: songMoveListView
        x: - appStyle.sidesMargin
        width: parent.width + 2 * appStyle.sidesMargin
        anchors.top: parent.top
        //anchors.topMargin: appStyle.sidesMargin
        anchors.bottom: previousNextRow.top
        anchors.bottomMargin: appStyle.sidesMargin

        onChangeMade: {
            page.changesMade = true
        }

        Connections {
            target: contentRoot
            onBack: {
                if (!active)
                    return

                if (!page.changesMade)
                {
                    discardChanges()
                    return
                }

                if (confirmDialog.visible)
                    discardChanges()

                confirmDialog.show(qsTr("Discard your modifications ?"),
                                   discardConfirmation)
            }
        }

        QtObject {
            id: discardConfirmation
            function onAccepted() {
                discardChanges()
            }
            function onRefused() {
                // Do nothing
            }
        }
    }

    ButtonsOkCancel {
        id: previousNextRow
        anchors.bottom: parent.bottom

        onAccepted: {
            saveChanges()
        }
        onRefused: {
            discardChanges()
        }
    }
}
