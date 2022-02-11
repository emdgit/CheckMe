#include "AppAPI_impl.h"
#include "AppAPI.h"
#include "MetricStorage.h"
#include"SignalNotifier.h"

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
