#include "MetricStorage.h"
#include "Enums.h"

#include <QtDebug>

constexpr auto data_type_key = "data_type";
constexpr auto start_date_key = "start_date";
constexpr auto metric_data_key = "metric_data";
constexpr auto date_key = "date";
constexpr auto value_key = "value";

using DataType = Enums::MetricDataType;

MetricStorage::MetricStorage() :
    settings_(QSettings("OGF Labs", "CheckMe")) {}

bool MetricStorage::familyExists(const QString &name) const
{
    return metricFamily(name) != nullptr;
}

bool MetricStorage::registerNewFamily(const QString &name, Enums::MetricDataType type)
{
    if (familyExists(name)) {
        return false;
    }

    metrics_.emplace_back(name, type, QDate::currentDate());
    return true;
}

void MetricStorage::upsertValue(const QString &family_name, const QDate &date,
                                const QVariant &value)
{
    auto m = metricFamily(family_name);

    if (!m) {
        return;
    }

    m->upsertData(date, value);
}

int MetricStorage::metricsCount() const
{
    return metrics_.size();
}

void MetricStorage::save()
{
    settings_.clear();

    for (const auto &m : metrics_) {
        settings_.beginGroup(m.name());

        settings_.setValue(data_type_key, static_cast<uint32_t>(m.dataType()));
        settings_.setValue(start_date_key, m.startDate());

        if (m.cbegin() != m.cend()) {
            settings_.beginWriteArray(metric_data_key);

            int i(0);
            for (auto it = m.cbegin(); it != m.cend(); ++it, ++i) {
                settings_.setArrayIndex(i);
                settings_.setValue(date_key, it->first.isValid() ? it->first
                                                                 : QDate::currentDate());
                settings_.setValue(value_key, it->second);
            }

            settings_.endArray();
        }

        settings_.endGroup();
    }
}

void MetricStorage::load()
{
    metrics_.clear();
    auto groups = settings_.childGroups();
    auto keys = settings_.allKeys();

    const auto key = [](const QString &g, const auto &k) {
        return QString(g + "/" + k);
    };

    for (const auto &g : groups) {
        DataType dt
            = static_cast<DataType>(settings_.value(key(g, data_type_key)).toUInt());
        QDate start = settings_.value(key(g, start_date_key)).toDate();

        Metric metric(g, dt, start);

        int size = settings_.beginReadArray(key(g, metric_data_key));
        for (int i = 0; i < size; ++i) {
              settings_.setArrayIndex(i);
              QDate d = settings_.value(date_key).toDate();
              QVariant v = settings_.value(value_key);

              metric.upsertData(d, v);
          }
          settings_.endArray();

          metric.normalize();
          metrics_.push_back(metric);
    }
}

Metric *MetricStorage::metricFamily(const QString &name) const
{
    auto it = std::find_if(metrics_.cbegin(), metrics_.cend(),
                        [&name](const auto &m){
        return m.name() == name;
    });

    return it == metrics_.cend() ? nullptr
                                 : const_cast<Metric*>(&*it);
}
