import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import QtQuick.Templates 2.12

import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Icons.js" as Icons

import App 1.0

/// Страница показвыает созданные метрики.
Item {

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

            Rectangle {
                id: dataRect
                width: parent.width
                height: 25
                color: "#3F51B5"
                radius: 8
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

//                Image {
//                    anchors {
//                        verticalCenter: parent.verticalCenter
//                        left: parent.left
//                        leftMargin: 10
//                    }
//                    height: 20
//                    width: 20

//                    source: API.icon()
//                    sourceSize {
//                        width: 20
//                        height: 20
//                    }
//                    Material.background: Material.Indigo
//                }


            }

            ItemDelegate {
                icon.source: Icons.tickSvg()
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
