#include "AppAPI.h"
#include "AppAPI_impl.h"
#include "MetricStorage.h"

#include <QThread>

AppAPI::AppAPI(ApiEnv env, QObject *parent) :
    QObject(parent), env_(env), impl_(new AppAPI_impl(&env_))
{
    thread_ = new QThread(this);
    impl_->moveToThread(thread_);
    thread_->start();
}

AppAPI::~AppAPI()
{
    // Stop thread and delete everything
}

void AppAPI::loadMetrics()
{
    QMetaObject::invokeMethod(impl_,
                              &AppAPI_impl::loadMetricsImpl,
                              Qt::QueuedConnection);
}

bool AppAPI::metricFamilyExists(const QString &name)
{
    return env_.metrics->familyExists(name);
}

void AppAPI::registerNewMetricFamily(const QString &name)
{
    QMetaObject::invokeMethod(impl_,
                              "registerNewMetricFamilyImpl",
                              Qt::QueuedConnection,
                              Q_ARG(QString, name));
}

