import QtQuick 2.0

import App 1.0

/// Страница показвыает созданные метрики.
Item {

    ListView {
        id: metricsList

        anchors.fill: parent

        model: MetricModel
    }
}
