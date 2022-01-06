#pragma once

#include <QSettings>

#include <vector>

#include "metric.h"

class MetricStorage
{
public:
    MetricStorage();

    bool familyExists(const QString &name) const;

    bool registerNewFamily(const QString &name);

    void upsertValue(const QString &family_name,
                     const QDate &date,
                     const QVariant &value);

    void save();
    void load();


protected:

    Metric * metricFamily(const QString &name) const;


private:
    std::vector<Metric> metrics_;

    QSettings settings_;
};
