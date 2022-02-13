import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12

import "qrc:/js/js/Colors.js" as Colors
import "qrc:/js/js/Icons.js" as Icons

Item {
    id: metricCardDelegateTop

    // Including item inside don't forget to
    // implement an 'implicitHeight' property.
    default property alias data: innerData.sourceComponent

    property alias iconSource: mIcon.source
    property alias iconColor: mIcon.color
    property alias topText: describeLabel.text

    signal updateClicked()
    signal resetClicked()

    implicitHeight: cLay.implicitHeight

    ColumnLayout {
        id: cLay

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            // Картинка и надпись про тип метрики.
            id: typeLine

            Item { height: 2; Layout.fillWidth: true; }
            MIcon { id: mIcon }
            Label { id: describeLabel }
            Item { height: 2; Layout.fillWidth: true; }
        }

        Loader {
            id: innerData
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 15
        }

        RowLayout {
            id: buttonsLayout

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
    }
}
