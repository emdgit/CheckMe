#pragma once

#include <QSettings>
#include <QAbstractListModel>

#include <vector>

#include "metric.h"

class QQuickItem;

namespace QtCharts {
class QAbstractSeries;
}

class MetricStorage
{
public:
    using VariantVec = std::vector<QVariant>;

    MetricStorage();

    bool familyExists(const QString &name) const;

    bool registerNewFamily(const QString &name,
                           Enums::MetricDataType type,
                           bool eachDay);

    bool removeFamily(const QString &name);

    void upsertValue(const QString &family_name,
                     const QDate &date,
                     const QVariant &value);

    void removeValue(const QString &family_name,
                     const QDate &date);

    int metricsCount() const;
    int metricType(int index) const;
    int metricType(const QString &name) const;

    QString metricName(int index) const;

    QDate startDate(int index) const;

    /*!
     * \param[in] index Номер семейства метрики.
     * \param[in] number Порядковый номер значения
     * внутри конкретной метрики.
     * \return Значение или QVariant().
     */
    QVariant data(int index, int number) const;

    void save();
    void load();

    void fillSeries(const QString &name,
                    QtCharts::QAbstractSeries *series) const;


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

    Q_INVOKABLE
    int metricType(int row) const;

    Q_INVOKABLE
    bool hasData(int row, int number) const;

    Q_INVOKABLE
    QVariant metricData(int row, int number) const;

    Q_INVOKABLE
    QString metricName(int row) const;

    Q_INVOKABLE
    QDate metricStartDate(int row) const;


public slots:

    void updateModel();


protected:

    Metric * metricFamily(const QString &name) const;


private:

    MetricStorage * st_;

};
