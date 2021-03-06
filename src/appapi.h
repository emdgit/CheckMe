#pragma once

#include <QObject>
#include <QIcon>

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
    void registerNewMetricFamily(const QString &name,
                                 int dataType,
                                 bool eachDay) const;

    Q_INVOKABLE
    void removeMetricFamily(const QString &name) const;

    Q_INVOKABLE
    void upsertMetricData(const QString &name,
                          const QDate &date,
                          const QVariant &data) const;

    Q_INVOKABLE
    void resetMetricData(const QString &name,
                         const QDate &date) const;


public slots:
    void finalize();

private:

    ApiEnv env_;

    AppAPI_impl * impl_;

    QThread * thread_;
};
