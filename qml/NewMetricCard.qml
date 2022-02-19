import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls.Material 2.12

import App 1.0
import App.Enums 1.0

import "qrc:/js/js/Icons.js" as Icons
import "qrc:/js/js/Colors.js" as Colors

/// Карточка создания новой метрики.
Item {
    id: newMetricCard

    readonly property int sideMargin: 20
    readonly property int verticalMargin: 15
    readonly property real buttonWidth: 113.46875

    readonly property alias metricName: nameField.text

    signal applyClicked(string name, int dataType, bool forEachDay)
    signal cancelClicked()
    signal backClicked()

    function dataType() {
        if (checkBoolean.checked) {
            return Enums.Boolean;
        } else if (checkInteger.checked) {
            return Enums.Integer;
        } else {
            return Enums.Time;
        }
    }

    /// Text for ToolTips.
    function questionText(key) {
        function randomInt(min, max) {
          return Math.floor(Math.random() * (max - min + 1) + min)
        }

        function randomTime() {
            const h = randomInt(0, 23);
            const m = randomInt(0, 59);

            let strOut = "";
            strOut += h < 10 ? "0" + h : h;
            strOut += ":" + m < 10 ? "0" + m : m;

            return strOut;
        }

        switch (key) {
        case Enums.NMCE_QuestionBool:
            return qsTr("Записи с этим типом данных могут принимать толко 2 значения: " +
                        "'Да' или 'Нет'.");
        case Enums.NMCE_QuestionInt:
            return qsTr("В таких записях можно будет сохранять целые числа. Например, " +
                        randomInt(0, 101), + ".");
        case Enums.NMCE_QuestionTime:
            return qsTr("Эти записи будут хранить значение времени. Как, допустим, " +
                        randomTime() + ". Ну, или " + randomTime() + ". Как пожелаете.");
        case Enums.NMCE_QuestionEachDay:
            return qsTr("Выбрав эту опцию, приложение будет просить заполнять данные " +
                        "каждый день. Пропуск дня будет считаться незаполненным и " +
                        "обязательным к заполнению.");
        default: return "";
        }
    }

    implicitHeight: buttonsRow.y + 4 * verticalMargin

    Keys.onBackPressed: { nameField.clear(); backClicked(); }
    Keys.onEscapePressed: { nameField.clear(); backClicked(); }

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
            right: hintBool.left
        }
        checked: true
        text: qsTr("Да/Нет")
        contentItem: MWrapContentLabel { }
        ButtonGroup.group: buttonGroup
    }

    RadioButton {
        id: checkInteger
        anchors {
            top: checkBoolean.bottom
            left: parent.left
            leftMargin: sideMargin
            right: hintInt.left
        }
        text: qsTr("Численное значение")
        contentItem: MWrapContentLabel {}
        ButtonGroup.group: buttonGroup
    }

    RadioButton {
        id: checkTime
        anchors {
            top:checkInteger.bottom
            left: parent.left
            leftMargin: sideMargin
            right: hintTime.left
        }
        text: qsTr("Время")
        contentItem: MWrapContentLabel {}
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

    MClickableIcon {
        id: hintBool

        anchors {
            verticalCenter: checkBoolean.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.questionSvg()
        color: Colors.pink()
        side: 20
        toolTipText: questionText(Enums.NMCE_QuestionBool)
    }

    MClickableIcon {
        id: hintInt

        anchors {
            verticalCenter: checkInteger.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.questionSvg()
        color: Colors.pink()
        side: 20
        toolTipText: questionText(Enums.NMCE_QuestionInt)
    }

    MClickableIcon {
        id: hintTime

        anchors {
            verticalCenter: checkTime.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.questionSvg()
        color: Colors.pink()
        side: 20
        toolTipText: questionText(Enums.NMCE_QuestionTime)
    }

    CheckBox {
        id: eachDayCheckBox

        anchors {
            top: separator.bottom
            left: parent.left
            leftMargin: sideMargin
            right: hintEachDay.left
        }

        text: qsTr("Требовать на каждый день.")
        checked: false
        contentItem: MWrapContentLabel {}
    }

    MClickableIcon {
        id: hintEachDay

        anchors {
            verticalCenter: eachDayCheckBox.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.questionSvg()
        color: Colors.pink()
        side: 20
        toolTipText: questionText(Enums.NMCE_QuestionEachDay)
        toolTipTimeout: 8000
    }

    ToolSeparator {
        id: separatorBottom
        anchors {
            top: eachDayCheckBox.bottom
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
            top: separatorBottom.bottom
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        Button {
            id: cancelButton
            text: qsTr("Отмена")
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
            enabled: isEnabled()
            onClicked: {
                let name = metricName;
                nameField.clear();
                newMetricCard.applyClicked(name,
                                           dataType(),
                                           eachDayCheckBox.checked);
            }
        }
    }
}
