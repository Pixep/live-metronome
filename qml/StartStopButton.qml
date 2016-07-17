import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    height: appStyle.controlHeight
    width: parent.width

    property bool playing: false
    property int tickIndex
    property int tickCount

    signal clicked()

    Button {
        id: playButton
        anchors.fill: parent
        text: root.playing ? "" : "Play"
        color: appStyle.headerColor

        onClicked: {
            root.clicked()
        }

        Item {
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
                    model: 4

                    Rectangle {
                        id: circle
                        width: height
                        height: parent.circleWidth
                        color: root.tickIndex == index ? appStyle.textColor : appStyle.textColor2
                        radius: 0.5 * width
                        Connections {
                            target: root
                            onPlayingChanged: {
                                if (playing && index == 0)
                                {
                                    circle.animate()
                                }
                            }
                        }
                        Connections {
                            target: root
                            onTickCountChanged: {
                                if (root.playing && (root.tickIndex % 4) == index)
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
        }
    }
}
