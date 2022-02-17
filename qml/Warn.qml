import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0

import "qrc:/js/js/Colors.js" as Colors

/// Used as a ContentItem of a Popup to warn about
/// deleting metric Family.
Item {
    id: warnTop

    readonly property int sideMargin: 20

    signal cancel()
    signal apply()

    Keys.onBackPressed: { cancel(); }
    Keys.onEscapePressed: { cancel(); }

    implicitHeight: warnLabel.height +
                    separatorTop.height +
                    describeLabel.height +
                    separatorBottom.height +
                    buttonsLayout.height +
                    30 // margins

    Label {
        id: warnLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            leftMargin: sideMargin
            rightMargin: sideMargin
        }
        horizontalAlignment: Label.AlignHCenter
        text: qsTr("Удаляем '<font color=\"" +
                   Colors.indigo() + "\">" +
                   warningPopup.name + "</font>'?")
        wrapMode: Label.WordWrap
    }

    ToolSeparator {
        id: separatorTop

        anchors {
            top: warnLabel.bottom
            left: parent.left
            leftMargin: warnTop.sideMargin
            right: parent.right
            rightMargin: warnTop.sideMargin
        }

        orientation: Qt.Horizontal
    }

    Label {
        id: describeLabel
        anchors {
            top: separatorTop.bottom
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        wrapMode: Label.WordWrap

        text: qsTr("Все записанные значения будут удалены \
и восстановить их уже будет невозможно..")
    }

    ToolSeparator {
        id: separatorBottom

        anchors {
            top: describeLabel.bottom
            left: parent.left
            leftMargin: warnTop.sideMargin
            right: parent.right
            rightMargin: warnTop.sideMargin
        }

        orientation: Qt.Horizontal
    }

    RowLayout {
        id: buttonsLayout

        anchors {
            top: separatorBottom.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Item { height: 2; Layout.fillWidth: true; }

        OvalFramedButton {
            text: qsTr("Оставим")
            borderColor: Colors.indigo()
            onClicked: { warnTop.cancel(); }
        }

        OvalFramedButton {
            text: qsTr("Удалим")
            borderColor: Colors.indigo()
            onClicked: { warnTop.apply(); }
        }

        Item { height: 2; Layout.fillWidth: true; }
    }
}
