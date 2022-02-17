import QtQuick 2.0
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

Popup {
    id: mPopupTop

    anchors.centerIn: parent
    width: parent.width * 0.75
    height: implicitContentHeight

    Behavior on height {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutBack
        }
    }

    focus: true
    modal: true
    closePolicy: Popup.CloseOnPressOutside

    background: Rectangle {
        color: Material.backgroundColor
        radius: 14
    }
}
