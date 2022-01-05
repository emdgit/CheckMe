import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

ApplicationWindow {
    id: window
    visible: true

    width: 600
    height: 400

    Material.theme: Material.Dark
    Material.accent: Material.DeepPurple

    header: ToolBar {
        id: toolBar

        ToolButton {
            id: callMenuButton

            icon.source: "qrc:/icons/icons/lined_menu.svg"

            onClicked: {
                drawer.open();
            }
        }
    }

    Drawer {
        id: drawer
        width: 0.66 * window.width
        height: window.height

        Label {
            text: "Content goes here!"
            anchors.centerIn: parent
        }
    }

}
