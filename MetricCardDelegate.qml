import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import "qrc:/js/js/Colors.js" as Colors
import "qrc:/js/js/Icons.js" as Icons

Item {
    id: metricCardDelegateTop

    default property alias data: innerData.data

    property alias iconSource: mIcon.source
    property alias iconColor: mIcon.color
    property alias topText: describeLabel.text

    signal updateClicked()
    signal resetClicked()

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

    RowLayout {
        id: buttonsLayout

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Item { height: 2; Layout.fillWidth: true; }

        OvalFramedButton {
            text: qsTr("Сбросить")
            borderColor: Colors.indigo()

            onClicked: {
                metricCardDelegateTop.resetClicked();
            }
        }

        OvalFramedButton {
            text: qsTr("Обновить")
            borderColor: Colors.indigo()

            onClicked: {
                metricCardDelegateTop.updateClicked();
            }
        }

        Item { height: 2; Layout.fillWidth: true; }
    }


    Item {
        id: innerData
        anchors {
            top: typeLine.bottom
            left: parent.left
            right: parent.right
            bottom: buttonsLayout.top
        }
    }
}
