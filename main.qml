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
        width: 0.35 * window.width
        height: window.height

        ListView {
            id: listView
            anchors.fill: parent

            headerPositioning: ListView.OverlayHeader
            header: Pane {
                id: header
                z: 2
                width: parent.width

                contentHeight: logo.height

                MenuSeparator {
                    parent: header
                    width: parent.width
                    anchors.verticalCenter: parent.bottom
                    visible: !listView.atYBeginning
                }
            }

            footer: ItemDelegate {
                id: footer
                text: qsTr("Footer")
                width: parent.width

                MenuSeparator {
                    parent: footer
                    width: parent.width
                    anchors.verticalCenter: parent.top
                }
            }

            model: 5

            delegate: ItemDelegate {
                text: qsTr("Title %1").arg(index + 1)
                width: parent.width
                onClicked: {
                    drawer.close();
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Component.onCompleted: {
        API.loadMetrics();
    }
}
