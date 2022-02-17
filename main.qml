import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons

import App 1.0
import App.Enums 1.0

ApplicationWindow {
    readonly property string noDataPage: "qrc:/NoDataPage.qml"
    readonly property string metricListPage: "qrc:/MetricsPage.qml"
    readonly property string metricDataPage: "qrc:/MetricDataPage.qml"

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

    // TODO: rename
    function newMetricHandler() {
        let count = MetricModel.metricsCount();
        if (count > 0) {
            if (cmpLoader.source == noDataPage) {
                cmpLoader.source = metricListPage;
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
        focus: true

        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        property string _name: ""
        property int _dataType: -1
        property int _metricIndex: -1
        property date _startDate: new Date()
        property int _status: Component.Null

        /// Handler for MetricsPage when metric is clicked.
        function _onMetricSelected() {
            source = metricDataPage;
            sourceComponent.focus = true;
        }

        function _closeMetricDataPage() {
            source = metricListPage;
        }

        onStatusChanged: {
            _status = status;
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.55
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
                text: qsTr("Выйти")
                width: parent.width

                onClicked: {
                    Qt.callLater(Qt.quit());
                }

                MenuSeparator {
                    parent: footer
                    width: parent.width
                    anchors.verticalCenter: parent.top
                }
            }

            delegate: Item {

                width: parent.width
                height: itemLabel.implicitHeight < 35 ? 40 : itemLabel.implicitHeight + 30

                Label {
                    id: itemLabel

                    anchors {
                        left: parent.left
                        leftMargin: 15
                        right: parent.right
                        rightMargin: 15
                        verticalCenter: parent.verticalCenter
                    }

                    horizontalAlignment: Label.AlignLeft
                    verticalAlignment: Label.AlignVCenter

                    text: listView.itemText(index)
                    width: parent.width
                    wrapMode: Label.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.itemClicked(index);
                    }
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

        closePolicy: Popup.CloseOnPressOutside

        background: Rectangle {
            color: Material.backgroundColor
            radius: 14
        }

        contentItem: NewMetricCard {
            id: metricCard
            focus: true
            onApplyClicked: {
                API.registerNewMetricFamily(name, dataType, forEachDay);
                addMetricPopup.close();
            }
            onCancelClicked: { addMetricPopup.close(); }
            onBackClicked: { addMetricPopup.close(); }
        }
    }

    Component.onCompleted: {
        cmpLoader.source = noDataPage;
        API.loadMetrics();
    }
}
