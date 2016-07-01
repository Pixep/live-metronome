import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    height: 80
    x: appStyle.sidesMargin
    width: parent.width - 2 * appStyle.sidesMargin

    property bool playing: false
    property int tickIndex

    signal clicked()

    Button {
        id: playButton
        anchors.fill: parent
        text: root.playing ? "" : "Play"

        onClicked: {
            root.clicked()
        }

        /*Rectangle {
            color: "red"
            width: height
            height: 0.5 * parent.height
            visible: root.playing && root.tickIndex % 2 == 1
            anchors.right: parent.right
            anchors.rightMargin: 0.5 * height
            anchors.verticalCenter: parent.verticalCenter
        }*/
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
                            onTickIndexChanged: {
                                if (root.tickIndex == index)
                                {
                                    circle.scale = 1/0.4
                                    circle.color = appStyle.textColor
                                    scaleAnimation.start()
                                    colorAnimation.start()
                                }
                            }
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
