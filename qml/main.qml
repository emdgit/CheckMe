import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons

import App 1.0
import App.Enums 1.0

ApplicationWindow {
    readonly property string noDataPage: "qrc:/qml/NoDataPage.qml"
    readonly property string metricListPage: "qrc:/qml/MetricsPage.qml"
    readonly property string metricDataPage: "qrc:/qml/MetricDataPage.qml"

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

        Image {
            id: appNameImg

            readonly property int w: 200
            readonly property int h: toolBar.height * 0.95

            width: w
            height: h

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            source: "qrc:/icons/icons/CheckMe.png"
            sourceSize {
                width: appNameImg.w
                height: appNameImg.h
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
        function onConfigCopyedToClipboard(positive) {
            if (positive) {
                notifYLabel.notify("Скопировано!", true);
            } else {
                notifYLabel.notify("Ошибка при копировании", false);
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
        focus: true

        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        /// Metric's name
        property string _name: ""

        /// Type of Metric's data (Enum)
        property int _dataType: -1

        /// Index of Metric in Storage
        property int _metricIndex: -1

        /// First date in Metric's data
        property date _startDate: new Date()

        /// Status of this Loader
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

        onClosed: {
            cmpLoader.forceActiveFocus();
        }

        ListView {
            id: listView
            anchors.fill: parent

            headerPositioning: ListView.OverlayHeader

            model: 2

            function itemClicked(num) {
                drawer.close();

                switch (num) {
                case 0:
                    drawer.newMetricClicked();
                    break;
                case 1:
                    API.copyConfigToClipboard();
                    break;
                }
            }

            function itemText(num) {
                switch (num) {
                case 0:
                    return qsTr("Добавить новую метрику");
                case 1:
                    return qsTr("Копировать метрики в буфер обмена")
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

    NotifyLabel {
        id: notifYLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 24
        }
    }

    Component.onCompleted: {
        cmpLoader.source = noDataPage;
        API.loadMetrics();
    }
}
