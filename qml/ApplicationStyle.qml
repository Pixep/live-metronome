import QtQuick 2.5
import QtQuick.Window 2.2

QtObject {
    // Colors
    property string textColor: "#f0f0f0"
    property string textColor2: "#c0c0c0"
    property string textColorDark: "#202020"
    property string headerColor: "#2D4271"
    property string headerColorDark: "#2D4271"
    property string backgroundColor: "#202020"
    property string backgroundColor2: "#505050"
    property string backgroundColor3: "#353535"
    property color highlightColor1: "#267255"
    property color highlightColor2: "#492D72"

    // Size factor
    property real pixelDensity: {
        if (platform.simulationMode)
            return platform.simulation.pixelDensity

        return Screen.pixelDensity
    }
    property real sizeFactor: {
        var factor = 1.4 * pixelDensity / 10

        // Limit to 1.4 (>10dpmm) and 0.7 (<5dpmm)
        return Math.min(1.4, Math.max(0.7, factor))
    }

    // Fonts
    property int baseFontSize: 30 * sizeFactor
    property int titleFontSize: 35 * sizeFactor
    property int smallFontSize: 20 * sizeFactor

    // Sizes
    property int borderRadius: 3 * sizeFactor
    property int margin: 10 * sizeFactor

    property int controlHeight: 80 * sizeFactor
    property int colMargin: margin
    property int width_col1: 1 * pageContainer.width / 6 - 0.5*margin
    property int width_col2: 2 * pageContainer.width / 6 - 0.5*margin
    property int width_col3: 3 * pageContainer.width / 6 - 0.5*margin
    property int width_col4: 4 * pageContainer.width / 6 - 0.5*margin
    property int width_col5: 5 * pageContainer.width / 6 - 0.5*margin
    property int width_col6: pageContainer.width
}
