import QtQuick 2.5
import QtMultimedia 5.5

import "../components"
import "../controls"
import "../dialogs"

Page {
    id: page
    y: page.bottomY / 4
    opacity: 0
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
        ParallelAnimation {
            id: newShowAnimation

            NumberAnimation {
                target: page
                property: "y"
                easing.overshoot: 1.200
                to: page.topY
                duration: 300
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                target: page
                property: "opacity"
                to: 1
                duration: 300
                easing.type: Easing.OutCubic
            }
        },

        SequentialAnimation {
            id: newHideAnimation

            ParallelAnimation {
                PropertyAnimation {
                    target: page
                    property: "y"
                    to: window.height / 4
                    duration: 300
                    easing.type: Easing.OutCubic
                }
                PropertyAnimation {
                    target: page
                    property: "opacity"
                    to: 0
                    duration: 200
                    easing.type: Easing.Linear
                }
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
        spacing: 2*appStyle.margin

        Row {
            width: parent.width
            height: appStyle.controlHeight

            BaseText {
                text: qsTr("Language") + application.trBind
                width: appStyle.width_col3
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }

            Button {
                id: languageButton
                width: appStyle.width_col3
                height: appStyle.controlHeight
                text: application.language

                onClicked: {
                    languagesDialog.show()
                }
            }
        }

        Row {
            width: parent.width
            height: appStyle.controlHeight

            BaseText {
                text: qsTr("Tick sound") + application.trBind
                width: appStyle.width_col3
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }

            Button {
                id: tickSoundButton
                width: appStyle.width_col3
                height: appStyle.controlHeight
                text: userSettings.tickSoundName

                onClicked: {
                    tickSoundsDialog.show()
                }
            }
        }
    }

    ActionDialog {
        id: languagesDialog

        Repeater {
            id: languagesRepeater
            model: ListModel {
                ListElement { label: "Deutsch"; code: 42 }
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
                    highTick.source = userSettings.highTickSoundUrl()
                    lowTick.source = userSettings.lowTickSoundUrl()

                    highTick.play()
                    //lowTickTimer.start()

                    tickSoundsDialog.close()
                }
            }
        }

        resources: [
            SoundEffect {
                id: highTick
                onLoadedChanged: {
                    if (status === SoundEffect.Ready)
                    {
                        play()
                        lowTickTimer.start()
                    }
                }
            },
            Timer {
                id: lowTickTimer
                interval: 500
                onTriggered: lowTick.play()
            },
            SoundEffect {
                id: lowTick
            }
        ]
    }
}
