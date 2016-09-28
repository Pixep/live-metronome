import QtQuick 2.5

import "../../dialogs"

ActionDialog {
    id: dialog

    signal renameSetlist()
    signal deleteSetlist()

    ActionDialogItem {
        text: qsTr("Rename")
        onClicked: {
            dialog.close()
            dialog.renameSetlist()
        }
    }
    ActionDialogItem {
        text: qsTr("Delete")
        onClicked: {
            dialog.close()
            dialog.deleteSetlist()
        }
    }
    ActionDialogItem {
        text: qsTr("Cancel")
        showSeparator: false
        onClicked: {
            dialog.close()
        }
    }
}
