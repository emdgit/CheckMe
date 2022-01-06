import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons
import App 1.0

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

            icon.source: Icons.linedMenuSvg()

            onClicked: {
                drawer.open();
            }
        }
    }

    Connections {
        target: Notifier
        function onMetricsLoaded() {
            let written = API.metricFamilyCount();
            if (written === 0) {
                stackView.push(noMetricsComponent);
            }
        }
    }

    Component {
        id: noMetricsComponent
        Item {
            anchors.centerIn: parent

            width: window.width / 2
            height: window.height / 2

            Label {
                text: qsTr("Nothing added yet..")
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Image {
                source: Icons.saimonCatPng()
                sourceSize {
                    width: 150
                    height: 150
                }
                anchors.centerIn: parent
            }
        }
    }

    StackView {
        id: stackView

        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
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

    Component.onCompleted: {
        API.loadMetrics();
    }
}
