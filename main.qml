import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons

import App 1.0

ApplicationWindow {
    readonly property string noDataPage: "qrc:/NoDataPage.qml"
    readonly property string metricListPage: "qrc:/MetricsPage.qml"

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
        id: notofierConnections
        target: Notifier
        function onMetricsLoaded() {
            newMetricHandler();
        }
        function onRegisteredNewMetricFamily(name) {
            newMetricHandler();
        }
        function onMetricStorageCleared() {
            cmpLoader.source = "";
            cmpLoader.source = noDataPage;
        }
    }

    function newMetricHandler() {
        let count = MetricModel.metricsCount();
        if (count > 0) {
            if (cmpLoader.source == noDataPage) {
                cmpLoader.source = metricListPage;
            }
        }
    }

    Connections {
        id: drawerConnections
        target: drawer
        function onNewMetricClicked() {
            addMetricPopup.open();
        }
    }

    Loader {
        id: cmpLoader
        asynchronous: true

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

        signal newMetricClicked()

        ListView {
            id: listView
            anchors.fill: parent

            headerPositioning: ListView.OverlayHeader

            model: 1

            function itemClicked(num) {
                drawer.close();

                switch (num) {
                case 0:
                    drawer.newMetricClicked();
                    break;
                }
            }

            function itemText(num) {
                switch (num) {
                case 0:
                    return qsTr("Добавить новую метрику");
                default:
                    return qsTr("Не задано..")
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

            delegate: ItemDelegate {
                text: listView.itemText(index)
                width: parent.width
                onClicked: {
                    listView.itemClicked(index);
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Popup {
        id: addMetricPopup

        focus: true
        modal: true
        anchors.centerIn: parent

        width: parent.width * 0.75

        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            color: Material.backgroundColor
            radius: 14
        }

        contentItem: NewMetricCard {
            id: metricCard
            onApplyClicked: {
                API.registerNewMetricFamily(name, dataType);
                addMetricPopup.close();
            }
            onCancelClicked: { addMetricPopup.close(); }
        }
    }

    Component.onCompleted: {
        cmpLoader.source = noDataPage;
        API.loadMetrics();
    }
}
