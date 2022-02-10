import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import "qrc:/js/js/Colors.js" as Colors

Item {
    default property alias data: innerData.data

    property alias iconSource: mIcon.source
    property alias iconColor: mIcon.color
    property alias topText: describeLabel.text

    signal updateClicked()

    anchors.fill: parent
    RowLayout {
        // Картинка и надпись про тип метрики.
        id: typeLine

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Item { height: 2; Layout.fillWidth: true; }
        MIcon { id: mIcon }
        Label { id: describeLabel }
        Item { height: 2; Layout.fillWidth: true; }
    }

    OvalFramedButton {
        id: updateButton

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        text: qsTr("Обновить")
        borderColor: Colors.indigo()

        onClicked: {
            parent.updateClicked();
        }
    }

    Item {
        id: innerData
        anchors {
            top: typeLine.bottom
            left: parent.left
            right: parent.right
            bottom: updateButton.top
        }
    }
}
