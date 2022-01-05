#pragma once

#include <QVariant>

#include <string>

class Metric
{
public:

    enum class Type {
        Boolean,
        Integer,
        Time
    };

    Metric() = delete;
    Metric(const QString &name, bool val);
    Metric(const QString &name, int val);
    Metric(const QString &name, const QTime &val);

    const QString & name() const;

    template <class T>
    T data() const {
        if constexpr (std::is_same_v<T, bool>) {
            if (type_ == Type::Boolean) {
                return qvariant_cast<T>(data_);
            } else if constexpr (std::is_integral_v<T>) {
                return static_cast<T>(qvariant_cast<int>(data_));
            } else if constexpr (std::is_same_v<T, QString>) {
                return qvariant_cast<QString>(data_);
            }

            throw std::runtime_error("Cannot cast to given type");
        }
    }

private:

    /// Наименование метрики.
    QString name_;

    /// Значение.
    QVariant data_;

    /// Тип метрики.
    Type type_;

};
