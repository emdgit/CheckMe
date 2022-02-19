#include "appapi.h"
#include "appapi_impl.h"
#include "chartmanager.h"
#include "metricstorage.h"
#include "signalnotifier.h"
#include "servicefunctions.h"

#include <QtCharts/QChart>

AppAPI_impl::AppAPI_impl(ApiEnv *env, QObject *parent) :
    QObject(parent), env_(env) {}

void AppAPI_impl::loadMetricsImpl()
{
    env_->metrics->load();
    env_->notifier->emitMetricsLoaded();
}

void AppAPI_impl::registerNewMetricFamilyImpl(const QString &name,
                                              int dataType,
                                              bool eachDay)
{
    if (env_->metrics->registerNewFamily(name, static_cast<Enums::MetricDataType>(dataType), eachDay)) {
        env_->metrics->save();
        env_->notifier->emitRegisteredNewMetricFamily(name);
    }
}

void AppAPI_impl::removeMetricFamilyImpl(const QString &name)
{
    if (env_->metrics->removeFamily(name)) {
        env_->metrics->save();
        env_->notifier->emitRemovedMetricFamily();

        if (!env_->metrics->metricsCount()) {
            env_->notifier->emitMetricStorageCleared();
        }
    }
}

void AppAPI_impl::upsertMetricDataImpl(const QString &name,
                                       const QDate &date,
                                       const QVariant &data)
{
    env_->metrics->upsertValue(name, date, data);
    env_->metrics->save();
    env_->notifier->emitMetricDataUpserted();
}

void AppAPI_impl::resetMetricDataImpl(const QString &name,
                                      const QDate &date) const
{
    env_->metrics->removeValue(name, date);
    env_->metrics->save();
    env_->notifier->emitMetricDataRemoved();
}

void AppAPI_impl::loadChartSeriesImpl(const QString &name,
                                      QQuickItem *qmlItem) const
{
    const auto type = env_->metrics->metricType(name);

    if (type < 0) {
        qDebug("Metric wasn't foud");
    }

    QtCharts::QAbstractSeries *series(nullptr);

    switch (type) {
    case Enums::Boolean:
        series = env_->charts->pieSeries();
        break;
    default:
        qDebug("Unsupported DataType");
        return;
    }

    if (!series) {
        qDebug("Series wasn't found");
        return;
    }

    auto chart = ServiceFunctions::findChart(qmlItem);
    if (!chart) {
        qDebug("Chart wasn't found");
        return;
    }

    env_->metrics->fillSeries(name, series);
    chart->removeAllSeries();
    chart->addSeries(series);
}
