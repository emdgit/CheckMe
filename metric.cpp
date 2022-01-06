#include "metric.h"

Metric::Metric(const QString &name) : name_(name) {}

Metric::Metric(const QString &name, const QDate &start) :
    name_(name), start_date_(start) {}

const QString &Metric::name() const
{
    return name_;
}

Metric::UpsertDataStatus Metric::upsertData(const QDate &date, const QVariant &val)
{
    using pair_t = std::pair<QDate,QVariant>;

    auto it = std::find_if(begin(), end(), [&date](const pair_t &p) {
        return p.first == date;
    });

    if (it == end()) {
        // Insert
        data_.emplace_back(date, val);
        return UpsertDataStatus::Inserted;
    } else {
        // Try Update
        if (it->second == val) {
            return UpsertDataStatus::Updated;
        }
        it->second = val;
    }

    return UpsertDataStatus::NoChanges;
}

const QDate &Metric::startDate() const
{
    return start_date_;
}

void Metric::setStartDate(const QDate &date)
{
    start_date_ = date;
}

Metric::DataType Metric::dataType() const noexcept
{
    return data_type_;
}

