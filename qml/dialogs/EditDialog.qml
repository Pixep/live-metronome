import QtQuick 2.5

import "../controls"

BaseDialog {
    id: dialog
    width: parent.width
    height: parent.height

    property QtObject target
    property alias value: editItem.text

    function show(title, targetObject)
    {
        value = ""
        titleText.text = title
        target = targetObject
        visible = true
        editItem.focus = true

        __show()
    }

    function close(accepted)
    {
        __close()

        if (accepted)
            dialog.target.onAccepted()
        else
            dialog.target.onRefused()
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
            spacing: appStyle.margin

            Item {
                width: parent.width
                height: titleText.height + 2 * appStyle.margin

                BaseText {
                    id: titleText
                    x: appStyle.margin
                    y: appStyle.margin
                    width: parent.width - 2 * appStyle.margin

                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            BaseEdit {
                id: editItem
                width: parent.width

                onUserValidated: {
                    dialog.close(true)
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
                        dialog.close(false)
                    }
                }
                ActionDialogItem {
                    iconSource: "qrc:/qml/images/icon_check.png"
                    width: parent.width / 2
                    showSeparator: false
                    onClicked: {
                        dialog.close(true)
                    }
                }
            }
        }
    }
}
