#include "chartmanager.h"
#include "metricstorage.h"

#include <QtCharts/QPieSeries>

#include <QQmlApplicationEngine>

ChartManager::ChartManager(MetricStorage *st) noexcept :
    st_(st)
{
    using engine = QQmlApplicationEngine;

    pie_ = new QtCharts::QPieSeries;

    engine::setObjectOwnership(pie_, engine::CppOwnership);

    QObject::connect(pie_, &QtCharts::QPieSeries::destroyed,
                     []{
        qDebug("Pie destroyed");
    });
}

QtCharts::QAbstractSeries *ChartManager::pieSeries() const
{
    return pie_;
}
