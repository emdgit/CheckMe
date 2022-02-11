#pragma once

#include <QVariant>
#include <QDate>

#include <vector>

#include "Enums.h"

class Metric
{
    using DataType = Enums::MetricDataType;
    using pair_t = std::pair<QDate,QVariant>;
    using vec_t = std::vector<pair_t>;
    using pair_it = vec_t::iterator;

public:
    enum class UpsertDataStatus {
        Inserted,
        Updated,
        NoChanges
    };

    Metric() = delete;
    Metric(const QString &name,
           Enums::MetricDataType type,
           bool forEachDay = false,
           const QDate &start = QDate::currentDate());

    const QString & name() const;

    UpsertDataStatus upsertData(const QDate &date,
                                const QVariant &val);

    void resetData(const QDate &date);

    const QDate &startDate() const;
    void setStartDate(const QDate &date);

    bool forEachDay() const noexcept;

    void normalize();

    size_t size() const noexcept;

    DataType dataType() const noexcept;

    inline auto begin() { return data_.begin(); }
    inline auto end() { return data_.end(); }
    inline auto cbegin() const { return data_.cbegin(); }
    inline auto cend() const { return data_.cend(); }


protected:

    pair_it find(const QDate &d);


private:

    /// Наименование метрики.
    QString name_;

    /// Дата начала.
    QDate start_date_;

    /// Тип метрики.
    DataType data_type_ = DataType::Boolean;

    /// Нужно ли требовать заполнения на каждый день.
    bool for_each_day_ = false;

    /// Значения.
    vec_t data_;
};
