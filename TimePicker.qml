import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0

import App.Funcs 1.0

Item {
    id: tumblerFrame

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
        const data = count === 24 ? modelData
                                  : modelData * 5;
        return data.toString().length < 2 ? "0" + data : data;
    }

    onHourChanged: {
        hoursTumbler.currentIndex = hour;
    }

    onMinuteChanged: {
        minutesTumbler.currentIndex = minute / 5;
    }

    Component {
        id: delegateComponent

        Label {
            text: tumblerFrame.formatText(Tumbler.tumbler.count, modelData)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //            font.pixelSize: fontMetrics.font.pixelSize * 2.25
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 5

        Item { height: 2; Layout.fillWidth: true; }

        Tumbler {
            id: hoursTumbler
            Layout.maximumHeight: tumblerFrame.height
            model: 24
            onCurrentIndexChanged: {
                hour = currentIndex;
            }
            delegate: delegateComponent
        }

        Tumbler {
            id: minutesTumbler
            Layout.maximumHeight: tumblerFrame.height
            model: 12
            delegate: delegateComponent
        }

        Item { height: 2; Layout.fillWidth: true; }
    }
}
