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
    void registerNewMetricFamilyImpl(const QString &name, int dataType);

    Q_INVOKABLE
    void removeMetricFamilyImpl(const QString &name);

    ApiEnv * env_;
};
