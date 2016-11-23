import QtQuick 2.5

import "../../dialogs"

ActionDialog {
    id: dialog

    signal renameSetlist()
    signal deleteSetlist()

    ActionDialogItem {
        text: qsTr("Rename") + application.trBind
        onClicked: {
            dialog.close()
            dialog.renameSetlist()
        }
    }
    ActionDialogItem {
        text: qsTr("Delete") + application.trBind
        onClicked: {
            dialog.close()
            dialog.deleteSetlist()
        }
    }
    ActionDialogItem {
        text: qsTr("Cancel") + application.trBind
        showSeparator: false
        onClicked: {
            dialog.close()
        }
    }
}
