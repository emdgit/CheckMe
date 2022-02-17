import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0

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

    property var editorData: undefined
    property int componentHeight: 0

    signal close()

    implicitHeight: dateLabel.height +
                    separator.height +
                    dataEditorLoader.implicitHeight + 30

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

    function _onClose() {
        dataEditorLoader.sourceComponent = undefined;
        editorData = undefined;
        metricCardTop.close();
    }

    Keys.onBackPressed: { _onClose(); }
    Keys.onEscapePressed: { _onClose(); }

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
        onClicked: { _onClose(); }
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

    Connections {
        target: Notifier
        function onMetricDataRemoved() {
            reloadData();
        }
    }

    Component {
        // Used when there is no data set.
        id: noDataCmp
        Item {
            implicitHeight: content.implicitHeight

            ColumnLayout {
                id: content
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: noDataLabel
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Label.AlignHCenter
                    text: qsTr("Пока нет данных..(")
                }

                OvalFramedButton {
                    id: setupButton
                    Layout.alignment: Qt.AlignHCenter

                    text: qsTr("Установить")

                    onClicked: {
                        switch (metricType) {
                        case Enums.Boolean:
                            editorData = true;
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
    }

    Component {
        id: booleanEditor
        MetricCardDelegate {
            property bool value

            iconSource: Icons.tickSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Да / Нет")

            onUpdateClicked: {
                API.upsertMetricData(_name, metricDate, value);
                _onClose();
            }

            onResetClicked: {
                API.resetMetricData(_name, metricDate);
            }

            data: Item {
                implicitHeight: radioButtons.implicitHeight

                Column {
                    id: radioButtons

                    RadioButton {
                        id: yesButton
                        checked: editorData === undefined ? true : editorData
                        text: qsTr("Да");
                        onCheckedChanged: {
                            value = checked;
                        }
                    }

                    RadioButton {
                        id: noButton
                        checked: editorData === undefined ? false : !editorData
                        text: qsTr("Нет");
                    }
                }
            }
        }
    }

    Component {
        id: integerEditor
        MetricCardDelegate {
            id: intDelegate

            property int value

            iconSource: Icons.numbersSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Численное значение")
            dataAlignment: Qt.AlignCenter

            onUpdateClicked: {
                API.upsertMetricData(_name, metricDate, value);
                _onClose();
            }

            onResetClicked: {
                API.resetMetricData(_name, metricDate);
            }

            data: SpinBox {
                editable: true
                from: -100500
                to: 100500

                onValueChanged: {
                    intDelegate.value = value
                }

                Component.onCompleted: {
                    this.value = editorData;
                }
            }
        }
    }

    Component {
        id: timeEditor
        MetricCardDelegate {
            id: timeDelegate

            property var value

            iconSource: Icons.clockSvg()
            iconColor: Colors.indigo()
            topText: qsTr("Время")
            dataAlignment: Qt.AlignCenter

            onUpdateClicked: {
                API.upsertMetricData(_name, metricDate, value);
                _onClose();
            }

            onResetClicked: {
                API.resetMetricData(_name, metricDate);
            }

            data: TimePicker {
                hour: {
                    if (editorData === undefined) {
                        return Funcs.currentHour();
                    }
                    return Funcs.extractHours(editorData);
                }

                minute: {
                    if (editorData === undefined) {
                        return Funcs.currentMinute();
                    }
                    return Funcs.extractMinutes(editorData);
                }

                onHourChanged: {
                    timeDelegate.value = Funcs.makeTime(hour, minute);
                }

                onMinuteChanged: {
                    timeDelegate.value = Funcs.makeTime(hour, minute);
                }
            }
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
