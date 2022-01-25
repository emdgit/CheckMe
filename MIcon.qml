import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: mIconTop

    property int side: 18

    property alias source: icon.source
    property alias color: colorOverlay.color

    width: side
    height: side

    Image {
        id: icon

        anchors.fill: parent
        height: mIconTop.side
        width: mIconTop.side

        sourceSize {
            width: mIconTop.side
            height: mIconTop.side
        }
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: icon
        source: icon
        antialiasing: true
    }
}
