import QtQuick 2.5

import "../components"
import "../controls"
import "../dialogs"

Page {
    id: page
    y: page.bottomY
    saveButtonsVisible: false
    showAnimation: newShowAnimation
    hideAnimation: newHideAnimation

    property int songIndex
    property bool lastFieldReached: false
    readonly property bool addingNewSong: songIndex < 0
    readonly property bool focusNextOnEnter: addingNewSong && !lastFieldReached

    function addNewSong()
    {
        songIndex = -1;
        clear()
        show()
        focusFirstField()
    }

    onActiveChanged: {
        if (active)
            lastFieldReached = false
    }

    // Cancel
    onDiscard: {
        hide()
    }

    // Save
    onSave: {
        // SAVE
        hide()
    }

    function prefill()
    {
        var song = userSettings.songsModel.get(songIndex)
        titleEdit.text = song.title
        artistEdit.text = song.artist
        tempoEdit.text = "" + song.tempo
        beatsPerMeasureEdit.text = "" + song.beatsPerMeasure
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

    Column {
        anchors.fill: parent

        BaseText {
            text: qsTr("Language") + application.trBind
        }

        Button {
            id: languageButton
            x: appStyle.width_col1
            width: appStyle.width_col5
            height: appStyle.controlHeight
            text: application.language
            anchors.right: parent.right

            onClicked: {
                languagesDialog.show()
            }
        }

        BaseText {
            text: qsTr("Tick sound") + application.trBind
        }

        Button {
            id: tickSoundButton
            x: appStyle.width_col1
            width: appStyle.width_col5
            height: appStyle.controlHeight
            text: userSettings.tickSoundName
            anchors.right: parent.right

            onClicked: {
                tickSoundsDialog.show()
            }
        }
    }

    ActionDialog {
        id: languagesDialog

        Repeater {
            id: languagesRepeater
            model: ListModel {
                ListElement { label: "English"; code: 31 }
                ListElement { label: "Français"; code: 37 }
                ListElement { label: "中国"; code: 25 }
                ListElement { label: "Spanish"; code: 111 }
            }

            ActionDialogItem {
                text: {
                    if (code === application.languageCode)
                        return "<b>" + label + "</b>"
                    else
                        return label
                }
                showSeparator: (index !== languagesRepeater.count-1)
                onClicked: {
                    userSettings.setPreferredLanguage(code)
                    languagesDialog.close()
                }
            }
        }
    }

    ActionDialog {
        id: tickSoundsDialog

        Repeater {
            id: tickSoundsRepeater
            model: userSettings.tickSoundsAvailable

            ActionDialogItem {
                text: {
                    if (index === userSettings.currentTickSoundIndex)
                        return "<b>" + modelData + "</b>"
                    else
                        return modelData
                }
                showSeparator: (index !== tickSoundsRepeater.count-1)
                onClicked: {
                    userSettings.setTickSound(index)
                    tickSoundsDialog.close()
                }
            }
        }
    }
}
