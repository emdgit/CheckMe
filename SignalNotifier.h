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

signals:

    void metricsLoaded();
    void registeredNewMetricFamily(QString);

};
