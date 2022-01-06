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

void AppAPI_impl::registerNewMetricFamilyImpl(const QString &name)
{
    if (env_->metrics->registerNewFamily(name)) {
        env_->notifier->emitRegisteredNewMetricFamily(name);
    }
}
