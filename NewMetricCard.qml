import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls.Material 2.12

/// Карточка создания новой метрики.
Item {

    readonly property int sideMargin: 20
    readonly property int verticalMargin: 15
    readonly property real buttonWidth: 113.46875

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
        }

        Item {
            height: 5
            Layout.fillWidth: true
        }

        Button {
            id: applyButton
            text: qsTr("Добавляем!")
            Layout.preferredWidth: buttonWidth
            Layout.minimumWidth: buttonWidth
        }
    }
}
