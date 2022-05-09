import QtQuick 2.0
import QtQuick.Controls 2.15

import "qrc:/js/js/Colors.js" as Colors

/// Появляющийся и исчезающий текст с уведомлением.
Rectangle {
    id: notifyLabelTop

    property alias text: notifyLabelText.text
    property bool isPositive: true

    readonly property int animationDuaration: 600

    function notify(message, positive) {
        text = message;
        isPositive = positive;
        state = "Showing";
    }

    Behavior on opacity {
        NumberAnimation {
            duration: animationDuaration
            easing.type: Easing.OutQuint
        }
    }

    /// Is used to turn off the visibility of all widget.
    Timer {
        id: timer
        interval: 1000
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            notifyLabelTop.state = "Hiding";
            console.log("Triggered")
        }
    }

    height: 35
    width: notifyLabelText.implicitWidth + 10
    border.color: isPositive ? Colors.lightGreen()
                             : Colors.red()
    color: Colors.transparent()
    radius: 10
    opacity: 0

    Label {
        id: notifyLabelText
        anchors.centerIn: parent
    }

    states: [
        State {
            name: "Showing"
            PropertyChanges {
                target: notifyLabelTop
                opacity: 1
            }
        },
        State {
            name: "Hiding"
            PropertyChanges {
                target: notifyLabelTop
                opacity: 0
            }
        }
    ]

    onStateChanged: {
        if (state === "Showing") {
            timer.start();
        }
    }
}
