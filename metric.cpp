#include "metric.h"

Metric::Metric(const QString &name, bool val) :
    name_(name), data_(val), type_(Type::Boolean) {}

Metric::Metric(const QString &name, int val) :
    name_(name), data_(val), type_(Type::Integer) {}

Metric::Metric(const QString &name, const QTime &val) :
    name_(name), data_(val), type_(Type::Time) {}

const QString &Metric::name() const
{
    return name_;
}
