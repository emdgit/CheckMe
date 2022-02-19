import QtQuick 2.0
import QtQuick 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.0
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
    focus: true

    Keys.onBackPressed: { _closeMetricDataPage(); }
    Keys.onEscapePressed: { _closeMetricDataPage(); }

    RowLayout {
        id: headerLayout

        anchors {
            top: parent.top
            topMargin: verticalMargin
            horizontalCenter: parent.horizontalCenter
        }

        Item { height: 2; Layout.fillWidth: true; }

        MIcon {
            source: Icons.dataTypeIcon(_dataType)
            color: Colors.white()
        }

        Label {
            text: _name
            color: Material.primaryTextColor
        }

        Item { height: 2; Layout.fillWidth: true; }
    }

    ToolSeparator {
        id: separator

        anchors {
            top: headerLayout.bottom
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
            verticalCenter: headerLayout.verticalCenter
            right: parent.right
            rightMargin: sideMargin
        }

        source: Icons.exitSvg()
        color: Colors.red()

        onClicked: {
            _closeMetricDataPage();
        }
    }

    MPopup {
        id: dayDataPopup

        property date selectedDate: new Date()

        property int familyNumber: _metricIndex
        property int dataNumber

        clip: true

        onOpened: {
            metricCard.reloadData();
        }

        onSelectedDateChanged: {
            let d = Funcs.dateDayDiff(_startDate,
                                      selectedDate);
            dataNumber = d;
        }

        contentItem: MetricCard {
            id: metricCard
            focus: true

            metricFamilyNumber: dayDataPopup.familyNumber
            metricDataNumber: dayDataPopup.dataNumber
            metricDate: dayDataPopup.selectedDate

            onClose: { dayDataPopup.close(); }
        }
    }

    SwipeView {
        id: swipeView

        anchors {
            top: headerLayout.bottom
            topMargin: verticalMargin
            left: parent.left
            right: parent.right
            bottom: pageIndicator.top
        }

        currentIndex: pageIndicator.currentIndex

        onCurrentIndexChanged: {
            if (currentIndex == 1) {
                commonChart.loadSeries();
            } else {
                commonChart.clearSeries();
            }
        }

        Calendar {
            id: metricCalendar

            readonly property date today: Funcs.currentDate()

            /// property in main.qml->Loader
            opacity: _status === Component.Ready ? 1 : 0
            locale: Qt.locale("ru_ru")
            maximumDate: today

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }

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

                        readonly property int num: Funcs.dateDayDiff(_startDate,
                                                                     styleData.date);
                        readonly property bool isToday: Funcs.dateDayDiff(metricCalendar.today,
                                                                          day()) === 0;
                        property bool inPeriod: _inPeriod()
                        property bool hasData: _hasData()

                        anchors {
                            fill: parent
                            margins: 2.4
                        }

                        radius: 5
                        color: dayColor()
                        border.color: borderColor()

                        function _inPeriod() {
                            const start = _startDate;
                            const date = styleData.date;
                            const today = metricCalendar.today;

                            return Funcs.dateLessEqual(start, date) &&
                                Funcs.dateLessEqual(date, today);
                        }

                        function _hasData() {
                            return MetricModel.hasData(_metricIndex, num);
                        }

                        function borderColor() {
                            if (!inPeriod) {
                                return Colors.transparent();
                            }

                            if (isToday) {
                                return styleData.hovered ? Colors.itemBlue()
                                                         : Colors.indigo();
                            }

                            if (!hasData) {
                                return Colors.red();
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
                            }

                            return Colors.transparent();
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
                                _startDate = MetricModel.metricStartDate(_metricIndex);
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
                                    if (!Funcs.dateLessEqual(styleData.date,
                                                             metricCalendar.today)) {
                                        return;
                                    }
                                }

                                dayDataPopup.selectedDate = dayDlg.day();
                                dayDataPopup.open();
                            }
                        }

//                        Component.onCompleted: {
//                            hasData = _hasData();
//                        }
                    }
                }
            }
        }

        ChartView {
            id: commonChart

            legend.alignment: Qt.AlignBottom
            antialiasing: true
            backgroundColor: Colors.transparent()
            legend.font {
                family: "Roboto Medium"
                pixelSize: 16
            }
            legend.labelColor: Material.primaryTextColor

            function loadSeries() {
                API.loadChartSeries(_name, commonChart);
            }

            function clearSeries() {

            }

        }
    }

    PageIndicator {
        id: pageIndicator
        interactive: true
        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onDestruction: {
        console.log("MetricDataPage DESTROYED")
    }
}
