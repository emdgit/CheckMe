import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import App 1.0
import App.Enums 1.0

/// Карточка добавления/редактирования данных
/// метрики за конкретную дату.
Item {
    id: metricCardTop

    required property int metricFamilyNumber
    required property int metricDataNumber

    readonly property int sideMargin: 20
    readonly property int metricType:
        MetricModel.metricType(metricFamilyNumber)
    readonly property int metricData:
        MetricModel.metricData(metricFamilyNumber,
                               metricDataNumber)

    Label {
        id: dateLabel

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        text: metricDate.toDateString()
    }

    ToolSeparator {
        id: separator

        anchors {
            top: dateLabel.bottom
            left: parent.left
            leftMargin: metricCardTop.sideMargin
            right: parent.right
            rightMargin: metricCardTop.sideMargin
        }

        orientation: Qt.Horizontal
    }

    Component {
        id: booleanEditor
        Item {}
    }

    Component {
        id: integerEditor
        Item {}
    }

    Component {
        id: timeEditor
        Item {}
    }

    Loader {
        id: dataEditorLoader

        sourceComponent: {
            switch (metricDataType) {
            case Enums.Boolean:
                return booleanEditor;
            case Enums.Integer:
                return integerEditor;
            case Enums.Time:
                return timeEditor;
            default: return undefined;
            }
        }
    }
}
