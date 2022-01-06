#pragma once

#include <QVariant>
#include <QDate>

#include <vector>

class Metric
{
public:

    enum class DataType : uint8_t {
        Boolean,
        Integer,
        Time,
        Unknown
    };

    enum class UpsertDataStatus {
        Inserted,
        Updated,
        NoChanges
    };

    Metric() = delete;
    Metric(const QString &name);
    Metric(const QString &name, const QDate &start);

    const QString & name() const;

    UpsertDataStatus upsertData(const QDate &date, const QVariant &val);

    const QDate &startDate() const;
    void setStartDate(const QDate &date);

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

    /// Значения.
    std::vector<std::pair<QDate,QVariant>> data_;

    /// Тип метрики.
    DataType data_type_ = DataType::Unknown;

};
