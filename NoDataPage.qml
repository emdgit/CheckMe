import QtQuick 2.0
import QtQuick.Controls 2.15

import "qrc:/js/js/Icons.js" as Icons

Item {
    anchors.fill: parent
    anchors.topMargin: 15

    width: window.width / 2
    height: window.height / 2

    Label {
        text: qsTr("Nothing added yet..")
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Image {
        source: Icons.saimonCatPng()
        sourceSize {
            width: 150
            height: 150
        }
        anchors.centerIn: parent
    }
}
