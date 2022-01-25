import QtQuick 2.15
import QtQuick.Templates 2.15 as T

Rectangle {
//    property alias tooltip: toolTipArea.tooltip
    property alias icon: icon.text
    property alias iconColor: icon.color
    property alias pixelSize: icon.font.pixelSize
    property alias horizontalAlignment: icon.horizontalAlignment

    color: "transparent"
    border.color: "transparent"

    T.Label {
        id: icon
        anchors.fill: parent
//        color: StudioTheme.Values.themeIconColor
        text: ""
//        font.family: StudioTheme.Constants.iconFont.family
//        font.pixelSize: StudioTheme.Values.myIconFontSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

}
