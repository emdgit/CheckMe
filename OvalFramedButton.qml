import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Material 2.12

import "qrc:/js/js/Colors.js" as Colors

/// Кнопка с овальной рамкой.
Rectangle {
    id: button

    signal clicked()

    required property string text

    property string borderColor: Colors.pink()
    property int preferableWidth: 100

    height: 30
    width: preferableWidth

    color: Material.backgroundColor
    border.color: borderColor
    radius: height / 2

    Material.theme: Material.Dark

    Label {
        id: buttonText
        text: button.text
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        color: Material.primaryTextColor
        font.pixelSize: 16
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            button.clicked();
        }
    }
}
