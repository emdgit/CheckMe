#include "AppAPI.h"
#include "AppAPI_impl.h"
#include "MetricStorage.h"

#include <QThread>

#include <iostream>

AppAPI::AppAPI(ApiEnv env, QObject *parent) :
    QObject(parent), env_(env), impl_(new AppAPI_impl(&env_))
{
    thread_ = new QThread(this);
    impl_->moveToThread(thread_);

    connect(thread_, &QThread::finished,
            impl_,   &AppAPI_impl::deleteLater);

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

bool AppAPI::metricFamilyExists(const QString &name) const
{
    return env_.metrics->familyExists(name);
}

void AppAPI::registerNewMetricFamily(const QString &name, int dataType)
{
    QMetaObject::invokeMethod(impl_,
                              "registerNewMetricFamilyImpl",
                              Qt::QueuedConnection,
                              Q_ARG(QString, name),
                              Q_ARG(int, dataType));
}

void AppAPI::finalize()
{
    try {
        thread_->quit();
        thread_->wait();
    }  catch (const std::exception &ex) {
        std::cout << "Exception: " << ex.what() << std::endl;
    }
}

