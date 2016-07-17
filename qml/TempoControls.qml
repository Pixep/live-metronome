import QtQuick 2.5
import QtQuick.Layouts 1.1

RowLayout {
    id: root
    height: appStyle.controlHeight
    width: parent.width

    readonly property int tempo: parseInt(tempoTextItem.text, 10)

    signal decreaseTempo()
    signal decreaseTempoLarge()
    signal increaseTempo()
    signal increaseTempoLarge()

    onDecreaseTempo: setTempo(tempo - 1)
    onDecreaseTempoLarge: setTempo(tempo - 10)
    onIncreaseTempo: setTempo(tempo + 1)
    onIncreaseTempoLarge: setTempo(tempo + 10)

    function setTempo(newTempo) {
        if (newTempo < 10)
            newTempo = 10
        else if (newTempo > 400)
            newTempo = 400

        tempoTextItem.text = newTempo.toString()
    }

    /*Button {
        height: parent.height
        Layout.fillWidth: true
        text: "<<"
        onClicked: parent.decreaseTempoLarge()
    }*/

    Button {
        height: parent.height
        Layout.fillWidth: true
        imageSource: "qrc:/qml/images/icon_minus.png"
        onClicked: parent.decreaseTempo()
    }

    Item {
        height: parent.height
        Layout.fillWidth: true

        TextInput {
            id: tempoTextItem
            text: "120"
            font.pixelSize: appStyle.titleFontSize
            color: appStyle.textColor
            anchors.centerIn: parent
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }

    Button {
        height: parent.height
        Layout.fillWidth: true
        imageSource: "qrc:/qml/images/icon_plus.png"
        onClicked: parent.increaseTempo()
    }

    /*Button {
        height: parent.height
        text: ">>"
        Layout.fillWidth: true
        onClicked: parent.increaseTempoLarge()
    }*/
}
