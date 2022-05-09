#pragma once

#include <QObject>

/// Класс для уведомлений о событиях.
class SignalNotifier : public QObject
{

    Q_OBJECT

public:
    explicit SignalNotifier(QObject *parent = nullptr);

    Q_INVOKABLE
    void emitMetricsLoaded();

    Q_INVOKABLE
    void emitRegisteredNewMetricFamily(const QString &name);

    Q_INVOKABLE
    void emitRemovedMetricFamily();

    Q_INVOKABLE
    void emitMetricStorageCleared();

    Q_INVOKABLE
    void emitMetricDataUpserted();

    Q_INVOKABLE
    void emitMetricDataRemoved();

    Q_INVOKABLE
    void emitConfigCopyedToClipboard(bool val);

signals:

    void metricsLoaded();
    void registeredNewMetricFamily(QString);
    void removedMetricFamily();
    void metricStorageCleared();
    void metricDataUpserted();
    void metricDataRemoved();
    void configCopyedToClipboard(bool);

};
