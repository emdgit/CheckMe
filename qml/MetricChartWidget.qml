import QtQuick 2.0
import QtCharts 2.3
import QtGraphicalEffects 1.15

import App 1.0

import "qrc:/js/js/Colors.js" as Colors

/// Shows metric's statistic chart and table
/// with related data.
Item {
    ChartView {
        id: chartView

        function loadSeries() {
            API.loadChartSeries(_name, commonChart);
        }

        antialiasing: true
        backgroundColor: Colors.transparent()
        legend.visible: false

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        margins.top: 0
        margins.bottom: 0
        clip: false

        height: 20

        Behavior on height {
            NumberAnimation {
                duration: 900
                easing.type: Easing.InExpo
            }
        }
    }

    Component {
        Glow {
            id: glow
            anchors.fill: chartView
            radius: 40
            samples: 80
            color: "#15bdff"
            source: chartView
        }
    }
}
