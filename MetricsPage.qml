import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import QtQuick.Templates 2.12

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons

import App 1.0
import App.Enums 1.0

/// Страница показвыает созданные метрики.
Item {

    Material.theme: Material.Dark

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
                let type = MetricModel.metricType(ind);
                switch (type) {
                case Enums.Boolean:
                    return Icons.tickSvg();
                case Enums.Integer:
                    return Icons.numbersSvg();
                case Enums.Time:
                    return Icons.clockSvg();
                default:
                    return "";
                }
            }

            Rectangle {
                id: dataRect
                width: parent.width
                height: 30
                radius: 8
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#3F51B5" }
                    GradientStop { position: 0.5; color: "#4b51bb" }
                    GradientStop { position: 1.0; color: "#3F51B5" }
                }

                Image {
                    id: icon
                    readonly property int imgSize: 18

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                    height: imgSize
                    width: imgSize

                    source: delegateElement.metricIcon(index)
                    sourceSize {
                        width: icon.imgSize
                        height: icon.imgSize
                    }
                }

                ColorOverlay {
                    anchors.fill: icon
                    source: icon
                    color: "#EEFFFFFF"
                    antialiasing: true
                }

                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: icon.right
                        leftMargin: 20
                    }
                    text: MetricModel.metricName(index)
                    color: Material.primaryTextColor
                }
            }

            DropShadow {
                anchors.fill: dataRect
                cached: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: "#80000000"
                source: dataRect
            }
        }
    }
}
