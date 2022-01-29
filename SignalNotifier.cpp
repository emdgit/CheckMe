#include "SignalNotifier.h"

SignalNotifier::SignalNotifier(QObject *parent) : QObject(parent) {}

void SignalNotifier::emitMetricsLoaded()
{
    emit metricsLoaded();
}

void SignalNotifier::emitRegisteredNewMetricFamily(const QString &name)
{
    emit registeredNewMetricFamily(name);
}

void SignalNotifier::emitRemovedMetricFamily()
{
    emit removedMetricFamily();
}

void SignalNotifier::emitMetricStorageCleared()
{
    emit metricStorageCleared();
}
