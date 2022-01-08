#pragma once

#include <QObject>

class AppAPI_impl;
class MetricStorage;
class SignalNotifier;

class QThread;

struct ApiEnv {
    MetricStorage * metrics;
    SignalNotifier * notifier;
};

/// Основной API приложения
class AppAPI : public QObject
{

    Q_OBJECT

public:
    explicit AppAPI(ApiEnv env, QObject *parent = nullptr);
    ~AppAPI() override;

    Q_INVOKABLE
    void loadMetrics();

    Q_INVOKABLE
    bool metricFamilyExists(const QString &name) const;

    Q_INVOKABLE
    void registerNewMetricFamily(const QString &name);

    Q_INVOKABLE
    int metricFamilyCount() const;

public slots:
    void finalize();

private:

    ApiEnv env_;

    AppAPI_impl * impl_;

    QThread * thread_;
};
