#pragma once

#include <QVariant>
#include <QDate>

#include <vector>

#include "Enums.h"

class Metric
{
    using DataType = Enums::MetricDataType;
public:
    enum class UpsertDataStatus {
        Inserted,
        Updated,
        NoChanges
    };

    Metric() = delete;
    Metric(const QString &name,
           Enums::MetricDataType type,
           const QDate &start = QDate::currentDate());

    const QString & name() const;

    UpsertDataStatus upsertData(const QDate &date, const QVariant &val);

    const QDate &startDate() const;
    void setStartDate(const QDate &date);

    void normalize();

    DataType dataType() const noexcept;

    inline auto begin() { return data_.begin(); }
    inline auto end() { return data_.end(); }
    inline auto cbegin() const { return data_.cbegin(); }
    inline auto cend() const { return data_.cend(); }

private:

    /// Наименование метрики.
    QString name_;

    /// Дата начала.
    QDate start_date_;

    /// Тип метрики.
    DataType data_type_ = DataType::Boolean;

    /// Значения.
    std::vector<std::pair<QDate,QVariant>> data_;
};
