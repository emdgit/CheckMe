#pragma once

class MetricStorage;

namespace QtCharts {
class QPieSeries;
class QAbstractSeries;
}

class ChartManager
{
public:
    explicit ChartManager(MetricStorage *st) noexcept;

    QtCharts::QAbstractSeries * pieSeries() const;


private:

    MetricStorage * st_;

    QtCharts::QPieSeries * pie_;

};
