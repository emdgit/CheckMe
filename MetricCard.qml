import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import App 1.0
import App.Enums 1.0

import "qrc:/js/js/Icons.js" as Icons
import "qrc:/js/js/Colors.js" as Colors

/// Карточка добавления/редактирования данных
/// метрики за конкретную дату.
Item {
    id: metricCardTop

    required property int metricFamilyNumber
    required property int metricDataNumber
    required property date metricDate

    readonly property int sideMargin: 20
    readonly property int metricType:
        MetricModel.metricType(metricFamilyNumber)
    readonly property var metricData:
        MetricModel.metricData(metricFamilyNumber,
                               metricDataNumber)

    signal close()

    implicitHeight: dataEditorLoader.x + 200

    Label {
        id: dateLabel

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        text: metricDate.toDateString()
    }

    MClickableIcon {
        id: closeIcon

        anchors {
            verticalCenter: dateLabel.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.exitSvg()
        color: Colors.red()
        onClicked: {
            metricCardTop.close();
        }
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

        anchors {
            top: separator.bottom
            left: parent.left
            right: parent.right
        }

        sourceComponent: {
            switch (metricType) {
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
