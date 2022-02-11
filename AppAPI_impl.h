#pragma once

#include <QObject>

struct ApiEnv;

class AppAPI_impl : public QObject
{
    Q_OBJECT

    friend class AppAPI;

    explicit AppAPI_impl(ApiEnv *env, QObject *parent = nullptr);

    Q_INVOKABLE
    void loadMetricsImpl();

    Q_INVOKABLE
    void registerNewMetricFamilyImpl(const QString &name, int dataType, bool eachDay);

    Q_INVOKABLE
    void removeMetricFamilyImpl(const QString &name);

    Q_INVOKABLE
    void upsertMetricDataImpl(const QString &name,
                              const QDate &date,
                              const QVariant &data);

    Q_INVOKABLE
    void resetMetricDataImpl(const QString &name,
                             const QDate &date) const;

    ApiEnv * env_;
};
