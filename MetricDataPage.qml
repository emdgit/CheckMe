import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.12

import App 1.0
import App.Funcs 1.0

import "qrc:/js/js/Icons.js" as Icons
import "qrc:/js/js/Colors.js" as Colors

/// Показывает данные по конкретной метрике, когда
/// таковая была выбрана. Тут же заполняются данные.
Item {
    id: metricDataPageTop

    readonly property int sideMargin: 20
    readonly property int verticalMargin: 15

    anchors.fill: parent

    Label {
        id: metricName

        anchors {
            top: parent.top
            topMargin: verticalMargin
            horizontalCenter: parent.horizontalCenter
        }

        text: _name
        color: Material.primaryTextColor
    }

    ToolSeparator {
        id: separator
        anchors {
            top: metricName.bottom
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
        }

        orientation: Qt.Horizontal
    }

    MClickableIcon {
        id: exitIcon

        anchors {
            verticalCenter: metricName.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.exitSvg()
        color: Colors.red()

        onClicked: {
            _closeMetricDataPage();
        }
    }

    Popup {
        id: dayDataPopup

        property date selectedDate: new Date()

        property int familyNumber: _metricIndex
        property int dataNumber

        anchors.centerIn: parent
        width: parent.width * 0.5

        focus: true
        modal: true
        closePolicy: Popup.NoAutoClose

        onOpened: {
            metricCard.reloadData();
        }

        onSelectedDateChanged: {
            let d = Funcs.dateDayDiff(_startDate,
                                      selectedDate);
            dataNumber = d;
        }

        background: Rectangle {
            color: Material.backgroundColor
            radius: 14
        }

        contentItem: MetricCard {
            id: metricCard

            metricFamilyNumber: dayDataPopup.familyNumber
            metricDataNumber: dayDataPopup.dataNumber
            metricDate: dayDataPopup.selectedDate

            onClose: { dayDataPopup.close(); }
        }
    }

    Calendar {
        id: metricCalendar

        anchors {
            top: metricName.bottom
            topMargin: verticalMargin
            left: parent.left
            leftMargin: sideMargin
            right: parent.right
            rightMargin: sideMargin
            bottom: parent.bottom
        }

        locale: Qt.locale("ru_ru")

        readonly property date today: Funcs.currentDate()

        style: CalendarStyle {
            gridColor: Colors.transparent()

            background: Rectangle {
                color: Colors.transparent()
            }

            navigationBar: Rectangle {
                color: Colors.transparent()
                width: metricCalendar.width
                height: 40

                Label {
                    id: navigationText
                    text: styleData.title
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: Material.primaryTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.capitalization: Font.AllUppercase
                }

                MClickableIcon {
                    id: leftArrow

                    anchors {
                        top: parent.top
                        topMargin: 10
                        right: navigationText.left
                        rightMargin: sideMargin
                    }

                    side: 20
                    source: Icons.leftArrowSvg()
                    color: Colors.white()

                    onClicked: {
                        metricCalendar.showPreviousMonth();
                    }
                }

                MClickableIcon {
                    id: rightArrow

                    anchors {
                        top: parent.top
                        topMargin: 10
                        left: navigationText.right
                        leftMargin: sideMargin
                    }

                    side: 20
                    source: Icons.rightArrowSvg()
                    color: Colors.white()

                    onClicked: {
                        metricCalendar.showNextMonth();
                    }
                }
            }

            dayOfWeekDelegate: Item {
                height: 30

                readonly property bool currentDay: {
                    let d = (new Date()).getDay();

                    if (1 <= d && d <= 6) {
                        --d;
                    } else {
                        d = 6;
                    }

                    return d === styleData.index;
                }

                Label {
                    text: day(styleData.index)
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: parent.currentDay ? Colors.pink()
                                             : Material.primaryTextColor

                    function day(num) {
                        switch (num) {
                        case 0:
                            return "ПН";
                        case 1:
                            return "ВТ";
                        case 2:
                            return "СР";
                        case 3:
                            return "ЧТ";
                        case 4:
                            return "ПТ";
                        case 5:
                            return "СБ";
                        case 6:
                            return "ВС";
                        }
                    }
                }
            }

            dayDelegate: Item {
                Rectangle {
                    id: dayDlg

                    readonly property bool inPeriod: {
                        const start = _startDate;
                        const date = styleData.date;
                        const today = metricCalendar.today;

                        return Funcs.dateLessEqual(start, date) &&
                            Funcs.dateLessEqual(date, today);
                    }
                    readonly property int num: Funcs.dateDayDiff(_startDate,
                                                                 styleData.date);
                    readonly property bool isToday: Funcs.dateDayDiff(metricCalendar.today,
                                                                      day()) === 0;

                    property bool hasData: false

                    anchors {
                        fill: parent
                        margins: 2.4
                    }

                    radius: 5
                    color: dayColor()
                    border.color: borderColor()

                    function _hasData() {
                        return MetricModel.hasData(_metricIndex, num);
                    }

                    function borderColor() {
                        if (!inPeriod) {
                            return Colors.transparent();
                        }

                        if (!hasData) {
                            return dayColor();
                        }

                        return Colors.indigo();
                    }

                    function dayColor() {
                        if (inPeriod) {
                            if (isToday) {
                                return Colors.indigo();
                            }

                            if (styleData.hovered) {
                                return Colors.itemBlue();
                            }

                            if (hasData) {
                                return Colors.transparent();
                            }

                            return Colors.red();
                        } else {
                            return Colors.transparent();
                        }
                    }

                    function day() { return styleData.date; }

                    Text {
                        text: styleData.date.toLocaleDateString(Qt.locale("ru_ru"),
                                                                "d")
                        anchors {
                            top: parent.top
                            topMargin: parent.height * 0.1
                            horizontalCenter: parent.horizontalCenter
                        }

                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        font.capitalization: Font.AllUppercase
                        color: {
                            if (dayDlg.inPeriod) {
                                return Colors.white();
                            } else {
                                return Colors.unactiveGray();
                            }
                        }
                    }

                    Component {
                        id: doubleTick
                        MIcon {
                            side: 15
                            source: Icons.doubleTickSvg()
                            color: Colors.lightGreen()
                        }
                    }

                    Connections {
                        target: Notifier
                        function onMetricDataUpserted() {
                            checkData();
                        }
                        function onMetricDataRemoved() {
                            checkData();
                        }
                        function checkData() {
                            dayDlg.hasData = MetricModel.hasData(_metricIndex,
                                                                 dayDlg.num);
                        }
                    }

                    Loader {
                        id: tickLoader

                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }

                        function getSourceCmp() {
                            if (dayDlg.inPeriod) {
                                const number = Funcs.dateDayDiff(_startDate,
                                                                 styleData.date);
                                if (dayDlg.hasData) {
                                    return doubleTick;
                                }
                            } else {
                                return undefined;
                            }
                        }

                        sourceComponent: getSourceCmp()
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!dayDlg.inPeriod) {
                                return;
                            }

                            dayDataPopup.selectedDate = dayDlg.day();
                            dayDataPopup.open();
                        }
                    }

                    Component.onCompleted: {
                        hasData = _hasData();
                    }
                }
            }
        }
    }

    Component.onDestruction: {
        console.log("MetricDataPage DESTROYED")
    }
}
