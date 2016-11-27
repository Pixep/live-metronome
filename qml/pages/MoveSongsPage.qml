import QtQuick 2.5

import "../components"
import "../controls"
import "MoveSongsPage"

Page {
    id: page
    showAnimation: newShowAnimation
    hideAnimation: newHideAnimation

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

    resources: [
        NumberAnimation {
            id: newShowAnimation
            target: page
            property: "y"
            easing.overshoot: 1.200
            to: page.topY
            duration: 300
            easing.type: Easing.OutCubic
        },

        SequentialAnimation {
            id: newHideAnimation

            PropertyAnimation {
                target: page
                property: "y"
                to: window.height
                duration: 300
                easing.type: Easing.InCubic
            }
            PropertyAction {
                target: page
                property: "visible"
                value: false
            }
        }
    ]


    MoveSongListView {
        id: songMoveListView
        x: - appStyle.margin
        width: parent.width + 2 * appStyle.margin
        anchors.top: parent.top
        //anchors.topMargin: appStyle.margin
        anchors.bottom: previousNextRow.top
        anchors.bottomMargin: appStyle.margin

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
                {
                    discardChanges()
                }
                else
                {
                    confirmDialog.show(qsTr("Discard your modifications ?"),
                                       discardConfirmation)
                }
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
