import QtQuick 2.5

import "../controls"

BaseDialog {
    width: parent.width
    height: parent.height
    visible: false

    property QtObject target

    function show(title, targetObject)
    {
        titleText.text = title
        target = targetObject
        visible = true

        __show()
    }

    function close(accepted)
    {
        __close()

        if (accepted)
            confirmDialog.target.onAccepted()
        else
            confirmDialog.target.onRefused()
    }

    Rectangle {
        id: background
        radius: appStyle.borderRadius
        anchors.centerIn: parent
        width: 0.8 * parent.width
        height: childrenRect.height + radius * 2
        color: "#333"

        Column {
            id: contentColumn
            y: appStyle.borderRadius
            width: parent.width
            height: childrenRect.height
            spacing: appStyle.sidesMargin

            Item {
                width: parent.width
                height: titleText.height + 2 * appStyle.sidesMargin

                BaseText {
                    id: titleText
                    x: appStyle.sidesMargin
                    y: appStyle.sidesMargin
                    width: parent.width - 2 * appStyle.sidesMargin

                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: separator
                color: appStyle.backgroundColor2
                width: parent.width
                height: 1

                Rectangle {
                    color: appStyle.backgroundColor2
                    width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: background.height - separator.y - contentColumn.y
                }
            }

            Row {
                height: childrenRect.height
                width: parent.width

                ActionDialogItem {
                    iconSource: "qrc:/qml/images/icon_clear.png"
                    width: parent.width / 2
                    showSeparator: false
                    onClicked: {
                        confirmDialog.close(false)

                    }
                }
                ActionDialogItem {
                    iconSource: "qrc:/qml/images/icon_check.png"
                    width: parent.width / 2
                    showSeparator: false
                    onClicked: {
                        confirmDialog.close(true)
                    }
                }
            }
        }
    }
}
