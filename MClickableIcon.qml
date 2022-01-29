import QtQuick 2.0

/// Кнопка с цветной .svg картинкой.
Item {

    id: mClickableIcon

    property alias side: mIcon.side
    property alias source: mIcon.source
    property alias color: mIcon.color

    signal clicked()

    width: mIcon.side
    height: mIcon.side

    MIcon { id: mIcon }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mClickableIcon.clicked();
        }
    }
}
