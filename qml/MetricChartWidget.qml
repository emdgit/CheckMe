import QtQuick 2.0
import QtCharts 2.3
import QtGraphicalEffects 1.15

import App 1.0
import App.Enums 1.0

import "qrc:/js/js/Colors.js" as Colors

/// Shows metric's statistic chart and table
/// with related data.
Item {
    function loadSeries() {
        API.loadChartSeries(_name, chartView);
    }

    function clearSeries() {}

    ChartView {
        id: chartView


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

//    Component {
//        id: glowCmp
        Glow {
            anchors.fill: chartView
            radius: 40
            samples: 80
            color: Colors.chartGlowColor()
            source:  {
                if (_dataType === Enums.Integer) {
                    return chartView;
                }

                return undefined;
            }
        }
//    }

//    Loader {
//        sourceComponent: {
//            if (_dataType === Enums.Integer) {
//                return glowCmp;
//            }

//            return undefined;
//        }
//    }
}
