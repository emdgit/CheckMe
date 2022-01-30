import QtQuick 2.0
import QtQuick.Controls 2.15

import "qrc:/js/js/Icons.js" as Icons
import "qrc:/js/js/Colors.js" as Colors

/// Показывает данные по конкретной метрике, когда
/// таковая была выбрана. Тут же заполняются данные.
Item {
    id: metricDataPageTop

    readonly property int sideMargin: 20
    readonly property int verticalMargin: 15

    anchors.fill: parent

    Label {
        id: metricName

        anchors {
            top: parent.top
            topMargin: verticalMargin
            horizontalCenter: parent.horizontalCenter
        }

        text: _d._name
    }

    MClickableIcon {
        id: exitIcon

        anchors {
            verticalCenter: metricName.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.exitSvg()
        color: Colors.red()

        onClicked: {
            _closeMetricDataPage();
        }
    }
}
