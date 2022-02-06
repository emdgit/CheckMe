import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import App 1.0
import App.Enums 1.0
import App.Funcs 1.0

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

    property var editorData

    signal close()

    implicitHeight: dataEditorLoader.x + 200

    function reloadData() {
        editorData
            = MetricModel.metricData(
                    metricCardTop.metricFamilyNumber,
                    metricCardTop.metricDataNumber);

        if (editorData === undefined) {
            dataEditorLoader.sourceComponent = noDataCmp;
            return;
        }

        dataEditorLoader.updateSourceComponent();
    }

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
            dataEditorLoader.sourceComponent = undefined;
            editorData = undefined;
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
        // Used when there is no data set.
        id: noDataCmp
        Item {
            anchors.fill: parent
            Label {
                id: noDataLabel
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                horizontalAlignment: Label.AlignHCenter
                text: qsTr("Пока нет данных..(")
            }
            OvalFramedButton {
                anchors.centerIn: parent
                text: qsTr("Установить")

                onClicked: {
                    switch (metricType) {
                    case Enums.Boolean:
                        editorData = false;
                        break;
                    case Enums.Integer:
                        editorData = 1;
                        break;
                    case Enums.Time:
                        editorData = Funcs.currentTime();
                        break;
                    }

                    dataEditorLoader.updateSourceComponent();
                }
            }
        }
    }

    Component {
        id: booleanEditor
        MetricCardDelegate {
            iconSource: Icons.tickSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Да / Нет")
            CheckBox {
                id: checkBox

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: sideMargin
                    right: parent.right
                    rightMargin: sideMargin
                }

                contentItem: Label {
                    text: checkBox.text
                    font: checkBox.font
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: checkBox.indicator.width + checkBox.spacing
                    wrapMode: Label.Wrap
                }

                checked: editorData
                text: checked ? qsTr("Да. (Галочка стоит)")
                              : qsTr("Нет. (Потому что галочка не стоит)")
            }
        }
    }

    Component {
        id: integerEditor
        MetricCardDelegate {
            iconSource: Icons.numbersSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Численное значение")
            SpinBox {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: sideMargin
                    right: parent.right
                    rightMargin: sideMargin
                }
                editable: true
                value: editorData
                from: -100500
                to: 100500
            }
        }
    }

    Component {
        id: timeEditor
        MetricCardDelegate {
            iconSource: Icons.clockSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Время")
        }
    }

    Loader {
        id: dataEditorLoader

        function updateSourceComponent() {
            switch (metricType) {
            case Enums.Boolean:
                sourceComponent = booleanEditor;
                break;
            case Enums.Integer:
                sourceComponent = integerEditor;
                break;
            case Enums.Time:
                sourceComponent = timeEditor;
                break;
            default: sourceComponent = undefined;
            }
        }

        anchors {
            top: separator.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
