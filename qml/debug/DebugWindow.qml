import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

Window {
    id: debugWindow
    visible: true
    x: appWindow.x + appWindow.width + 20
    y: appWindow.y
    width: 50
    height: column.height
    color: "#202020"
    flags: Qt.FramelessWindowHint

    property Window appWindow

    Connections {
        target: appWindow
        onClosing: {
            debugWindow.close()
        }
    }

    ColumnLayout {
        id: column
        width: parent.width

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: "DPI: " + platform.simulation.dpi.toFixed(0)
            horizontalAlignment: Text.AlignHCenter
            color: "white"
        }

        Button {
            Layout.fillWidth: true
            height: width
            text: "DPI++"
            onClicked: {
                platform.simulation.dpi = platform.simulation.dpi * 1.3
            }
        }
        Button {
            Layout.fillWidth: true
            height: width
            text: "DPI--"
            onClicked: {
                platform.simulation.dpi = platform.simulation.dpi / 1.3
            }
        }
    }
}
