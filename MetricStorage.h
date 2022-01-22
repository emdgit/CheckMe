#pragma once

#include <QSettings>
#include <QAbstractListModel>

#include <vector>

#include "metric.h"

class MetricStorage
{
public:
    MetricStorage();

    bool familyExists(const QString &name) const;

    bool registerNewFamily(const QString &name,
                           Enums::MetricDataType type);

    void upsertValue(const QString &family_name,
                     const QDate &date,
                     const QVariant &value);

    int metricsCount() const;

    void save();
    void load();


protected:

    Metric * metricFamily(const QString &name) const;


private:
    std::vector<Metric> metrics_;

    QSettings settings_;
};



class MetricModel : public QAbstractListModel
{

    Q_OBJECT

public:
    explicit MetricModel(MetricStorage *ms,
                         QObject *parent = nullptr);

    // QAbstractItemModel interface
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE
    int metricsCount() const;


protected:

    Metric * metricFamily(const QString &name) const;


private:

    MetricStorage * st_;

};
