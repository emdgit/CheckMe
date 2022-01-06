#include "metric.h"

Metric::Metric(const QString &name, const QDate &start) :
    name_(name), start_date_(start) {}

const QString &Metric::name() const
{
    return name_;
}

Metric::UpsertDataStatus Metric::upsertData(const QDate &date, const QVariant &val)
{
    using pair_t = std::pair<QDate,QVariant>;

    if (date.daysTo(start_date_) > 0) {
        throw std::runtime_error("Cannot set date earlier than start date");
    }
    if (date.daysTo(QDate::currentDate()) < 0) {
        throw std::runtime_error("Cannot set date later than today");
    }

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

void Metric::normalize()
{
    if (data_.empty()) {
        return;
    }

    auto q = data_.begin();
    auto p = q;
    ++p;

    const auto insert_empty = [&](int diff, QDate from, auto it) {
        decltype (data_) gap(diff - 1);
        for (int i(0); i < diff - 1; ++i) {
            gap[i] = std::make_pair<QDate, QVariant>(from.addDays(1), {});
            from = from.addDays(1);
        }
        auto first = data_.insert(it, gap.begin(), gap.end());
        auto second = first;
        ++second;

        return std::make_tuple(first, second);
    };

    while (p != data_.end()) {
        if (int d = q->first.daysTo(p->first); d == 1) {
            ++q; ++p;
            continue;
        } else {
            auto [f, s] = insert_empty(d, q->first, p);
            q = f; p = s;
        }
    }

    if (int d = data_.back().first.daysTo(QDate::currentDate()); d > 0) {
        insert_empty(d + 1, data_.back().first, data_.end());
    }

    if (int d = data_.front().first.daysTo(start_date_); d < 0) {
        insert_empty(std::abs(d) + 1, start_date_.addDays(-1), data_.begin());
    }

    data_.shrink_to_fit();
}

Metric::DataType Metric::dataType() const noexcept
{
    return data_type_;
}

