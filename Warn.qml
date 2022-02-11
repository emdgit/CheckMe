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

    Label {
        id: warnLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 15
        }
        text: qsTr("Удаляем '" + warningPopup.name + "'?")
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
        anchors {
            top: separatorTop.bottom
            left: parent.left
            right: parent.right
            bottom: separatorBottom.top
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
            left: parent.left
            leftMargin: warnTop.sideMargin
            right: parent.right
            rightMargin: warnTop.sideMargin
            bottom: buttonsLayout.top
        }

        orientation: Qt.Horizontal
    }

    RowLayout {
        id: buttonsLayout

        anchors {
            bottom: parent.bottom
            bottomMargin: 15
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
