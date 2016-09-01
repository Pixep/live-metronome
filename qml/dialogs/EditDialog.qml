import QtQuick 2.5

import "../controls"

BaseDialog {
    width: parent.width
    height: parent.height

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

                Rectangle {
                    color: appStyle.backgroundColor2
                    width: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: background.height - separator.y - contentColumn.y
                }
            }
        }
    }
}
