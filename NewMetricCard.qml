import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls.Material 2.12

import App 1.0
import App.Enums 1.0

/// Карточка создания новой метрики.
Item {
    id: newMetricCard

    readonly property int sideMargin: 20
    readonly property int verticalMargin: 15
    readonly property real buttonWidth: 113.46875

    readonly property alias metricName: nameField.text

    signal applyClicked(string name, int dataType)
    signal cancelClicked()

    function dataType() {
        if (checkBoolean.checked) {
            return Enums.Boolean;
        } else if (checkInteger.checked) {
            return Enums.Integer;
        } else {
            return Enums.Time;
        }
    }

    implicitHeight: buttonsRow.y + buttonsRow.height + 2 * verticalMargin

    MouseArea {
        anchors.fill: parent
        onClicked: {
            forceActiveFocus();
        }
    }

    TextField {
        id: nameField

        anchors {
            top: parent.top
            topMargin: verticalMargin
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        placeholderText: qsTr("Как назовем? =)")
        horizontalAlignment: TextInput.AlignHCenter
    }

    Label {
        id: questionLabel
        anchors {
            top: nameField.bottom
            topMargin: verticalMargin
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        horizontalAlignment: Label.AlignHCenter

        text: qsTr("Что будем записывать?")
    }

    ButtonGroup { id: buttonGroup }

    RadioButton {
        id: checkBoolean
        anchors {
            top: questionLabel.bottom
            left: parent.left
            leftMargin: sideMargin
        }
        checked: true
        text: qsTr("Да/Нет")
        ButtonGroup.group: buttonGroup
    }

    RadioButton {
        id: checkInteger
        anchors {
            top: checkBoolean.bottom
            left: parent.left
            leftMargin: sideMargin
        }
        text: qsTr("Численное значение")
        ButtonGroup.group: buttonGroup
    }

    RadioButton {
        id: checkTime
        anchors {
            top:checkInteger.bottom
            left: parent.left
            leftMargin: sideMargin
        }
        text: qsTr("Время")
        ButtonGroup.group: buttonGroup
    }

    ToolSeparator {
        id: separator
        anchors {
            top: checkTime.bottom
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        orientation: Qt.Horizontal
    }

    RowLayout {
        id: buttonsRow

        anchors {
            top: separator.bottom
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        Button {
            id: cancelButton
            text: qsTr("Отмена")
            Layout.preferredWidth: buttonWidth
            Layout.minimumWidth: buttonWidth
            onClicked: {
                nameField.clear();
                newMetricCard.cancelClicked();
            }
        }

        Item {
            height: 5
            Layout.fillWidth: true
        }

        Button {
            id: applyButton

            function isEnabled() {
                if (metricName === "") {
                    return false;
                }
                return !API.metricFamilyExists(metricName);
            }

            text: qsTr("Добавляем!")
            Layout.preferredWidth: buttonWidth
            Layout.minimumWidth: buttonWidth
            enabled: isEnabled()
            onClicked: {
                let name = metricName;
                nameField.clear();
                newMetricCard.applyClicked(name, dataType());
            }
        }
    }
}
