import QtQuick 2.5
import QtQuick.Window 2.2

QtObject {
    property int borderRadius: 5 * sizeFactor
    property int sidesMargin: 10 * sizeFactor
    property string textColor: "#f0f0f0"
    property string textColor2: "#c0c0c0"
    property string textColorDark: "#202020"
    property string headerColor: "#354582"
    property string headerColorDark: "#2a3251"
    property string backgroundColor: "#202020"
    property string backgroundColor2: "#656565"
    property string backgroundColor3: "#353535"
    property int baseFontSize: 30 * sizeFactor
    property int titleFontSize: 35 * sizeFactor
    property int smallFontSize: 20 * sizeFactor
    property int controlHeight: 80 * sizeFactor
    property int colMargin: sidesMargin
    property int width_col1: 1 * pageContainer.width / 6 - 0.5*sidesMargin
    property int width_col2: 2 * pageContainer.width / 6 - 0.5*sidesMargin
    property int width_col3: 3 * pageContainer.width / 6 - 0.5*sidesMargin
    property int width_col4: 4 * pageContainer.width / 6 - 0.5*sidesMargin
    property int width_col5: 5 * pageContainer.width / 6 - 0.5*sidesMargin
    property int width_col6: pageContainer.width
    property real sizeFactor: {
        if (Screen.pixelDensity < 5)
            return 1
        if (Screen.pixelDensity < 10)
            return 1.22
        if (Screen.pixelDensity > 10)
            return 1.4
    }
}
