import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12

import App.Funcs 1.0

Item {
    width: frame.implicitWidth + 10
    height: frame.implicitHeight + 10

    property int hour: Funcs.currentHour()
    property int minute: Funcs.currentMinute()

    function setTime(hours, minutes) {
        if (hours < 0 || hours > 23) {
            console.log("Cannot set hours value.")
            hour = Funcs.currentHour();
            return;
        } else {
            hour = hours;
        }

        if (minutes < 0 || minutes > 60) {
            minute = Funcs.currentMinute();
            console.log("Cannot set minutes value.")
            return;
        } else {
            minute = minutes;
        }
    }

    function formatText(count, modelData) {
        var data = count === 24 ? modelData + 1 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }

    FontMetrics {
        id: fontMetrics
    }

    Component {
        id: delegateComponent

        Label {
            text: formatText(Tumbler.tumbler.count, modelData)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
//            font.pixelSize: fontMetrics.font.pixelSize * 2.25
        }
    }

    Frame {
        id: frame
        padding: 0
        anchors.centerIn: parent

        background: Rectangle {
            gradient: Gradient {
                GradientStop {position: 0.0; color: "#AA0000FF"}
                GradientStop {position: 0.5; color: "#880000FF"}
                GradientStop {position: 1.0; color: "#AA0000FF"}
            }
        }

        Row {
            id: row

            Tumbler {
                id: hoursTumbler
                model: 24
                delegate: delegateComponent
            }

            Tumbler {
                id: minutesTumbler
                model: 60
                delegate: delegateComponent
            }
        }
    }
}
