import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    height: appStyle.controlHeight * 1.25
    width: parent.width

    property bool playing: false

    property int beatIndex
    property int beatTotalCount
    property int beatsPerMeasure

    signal clicked()

    Button {
        id: playButton
        anchors.fill: parent
        text: root.playing ? qsTr("Stop") : qsTr("Play")
        color: pressed ? appStyle.headerColorDark : appStyle.headerColor
        opacity: 1

        onClicked: {
            root.clicked()
        }

        /*Item {
            width: parent.width
            height: parent.height
            visible: root.playing

            Rectangle {
                color: appStyle.textColor2
                height: 0.20 * circlesRow.circleWidth
                width: circlesRow.width - 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: circlesRow
                width: 0.6 * parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: circleWidth
                spacing: (width - repeater.count * circleWidth) / (repeater.count - 1)
                anchors.verticalCenter: parent.verticalCenter

                property int circleWidth: 0.4 * parent.height

                Repeater {
                    id: repeater
                    model: root.beatsPerMeasure

                    Rectangle {
                        id: circle
                        width: height
                        height: parent.circleWidth
                        color: root.beatIndex == index ? appStyle.textColor : appStyle.textColor2
                        radius: 0.5 * width
                        Connections {
                            target: root
                            onPlayingChanged: {
                                if (playing && index == 0)
                                {
                                    circle.animate()
                                }
                            }
                            onBeatTotalCountChanged: {
                                if (root.playing && (root.beatIndex % root.beatsPerMeasure) == index)
                                {
                                    circle.animate()
                                }
                            }
                        }

                        function animate()
                        {
                            scale = 1/0.4
                            color = appStyle.textColor
                            scaleAnimation.start()
                            colorAnimation.start()
                        }

                        NumberAnimation on scale {
                            id: scaleAnimation
                            to: 1
                        }
                        ColorAnimation on color {
                            id: colorAnimation
                            to: appStyle.textColor2
                        }
                    }
                }
            }
        }*/
    }
}
