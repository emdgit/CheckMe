import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons
import "qrc:/js/js/Colors.js" as Colors

import App 1.0
import App.Enums 1.0

/// Страница показвыает созданные метрики.
Item {
    id: metricsPageTop

    readonly property int sideMargin: 20

    MPopup {
        id: warningPopup

        property string name: ""

        contentItem: Warn {
            focus: true
            onCancel: { warningPopup.close(); }

            onApply: {
                API.removeMetricFamily(warningPopup.name);
                warningPopup.close();
            }
        }
    }

    ListView {
        id: metricsList

        anchors {
            fill: parent
            margins: 15
        }

        model: MetricModel
        spacing: 5

        delegate: Item {
            id: delegateElement

            width: metricsList.width
            height: 35

            /// Which icon need to show.
            function metricIcon(ind) {
                const type = MetricModel.metricType(ind);
                return Icons.dataTypeIcon(type);
            }

            Rectangle {
                id: dataRect

                readonly property int sideMargin: 10

                width: parent.width
                height: 30
                radius: 8
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Colors.itemBlue(); }
                    GradientStop { position: 0.5; color: Colors.itemBlueGradient(); }
                    GradientStop { position: 1.0; color: Colors.itemBlue(); }
                }

                MIcon {
                    id: metricImage

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: dataRect.sideMargin
                    }

                    source: metricIcon(index)
                    color: Colors.white()
                }

                Label {
                    id: nameLabel
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: metricImage.right
                        leftMargin: 20
                    }
                    text: MetricModel.metricName(index)
                    color: Material.primaryTextColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        _name = nameLabel.text;
                        _dataType = MetricModel.metricType(index);
                        _startDate = MetricModel.metricStartDate(index);
                        _metricIndex = index;
                        // Function defined in Loader
                        // main.qml (cmpLoader)
                        _onMetricSelected();
                    }
                }

                MClickableIcon {
                    id: removeIcon

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: dataRect.sideMargin
                    }

                    source: Icons.trashSvg()
                    color: Colors.red()

                    onClicked: {
                        warningPopup.name = nameLabel.text;
                        warningPopup.open();
                    }
                }

                MClickableIcon {
                    id: editIcon

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: removeIcon.left
                        rightMargin: dataRect.sideMargin
                    }

                    source: Icons.editSvg()
                    color: Colors.white()
                }
            }

            DropShadow {
                anchors.fill: dataRect
                cached: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: Colors.shadow()
                source: dataRect
            }
        }
    }
}
