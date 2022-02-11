#include "MetricStorage.h"
#include "Enums.h"

#include <QtDebug>

constexpr auto data_type_key = "data_type";
constexpr auto start_date_key = "start_date";
constexpr auto metric_data_key = "metric_data";
constexpr auto metric_each_day_key = "for_each_day";
constexpr auto date_key = "date";
constexpr auto value_key = "value";

using DataType = Enums::MetricDataType;

MetricStorage::MetricStorage() :
    settings_(QSettings("OGF Labs", "CheckMe")) {}

bool MetricStorage::familyExists(const QString &name) const
{
    return metricFamily(name) != nullptr;
}

bool MetricStorage::registerNewFamily(const QString &name,
                                      Enums::MetricDataType type,
                                      bool eachDay)
{
    QString formatted;
    formatted += name.front().toUpper();

    std::generate_n(std::back_inserter(formatted), name.size() - 1,
                    [it = name.begin()]() mutable {
        return (++it)->toLower();
    });

    qDebug() << "Add new Family. Name = "
             << formatted
             << ", type = "
             << type;

    if (familyExists(formatted)) {
        qDebug() << "Family with name = "
                 << formatted
                 << " already exists. "
                 << "won't be registed.";
        return false;
    }

    metrics_.emplace_back(formatted, type, eachDay, QDate::currentDate());
    return true;
}

bool MetricStorage::removeFamily(const QString &name)
{
    auto it = std::find_if(metrics_.begin(), metrics_.end(),
                           [&name](const Metric &m){
        return !m.name().compare(name, Qt::CaseInsensitive);
    });

    if (it == metrics_.end()) {
        return false;
    }

    metrics_.erase(it);
    metrics_.shrink_to_fit();

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

int MetricStorage::metricType(int index) const
{
    return metrics_[index].dataType();
}

QString MetricStorage::metricName(int index) const
{
    return metrics_[index].name();
}

QDate MetricStorage::startDate(int index) const
{
    return metrics_[index].startDate();
}

QVariant MetricStorage::data(int index, int number) const
{
    const auto required_date = startDate(index).addDays(number);
    auto it = std::find_if(metrics_[index].cbegin(),
                           metrics_[index].cend(),
                           [&required_date](const auto &d){
        return d.first == required_date;
    });

    if (it == metrics_[index].cend()) {
        return {};
    }

    return it->second;
}

void MetricStorage::save()
{
    settings_.clear();

    for (const auto &m : metrics_) {
        settings_.beginGroup(m.name());

        settings_.setValue(data_type_key, static_cast<uint32_t>(m.dataType()));
        settings_.setValue(start_date_key, m.startDate());
        settings_.setValue(metric_each_day_key, m.forEachDay());

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
        bool for_each_day = settings_.value(key(g, metric_each_day_key)).toBool();

        Metric metric(g, dt, for_each_day, start);

        int size = settings_.beginReadArray(key(g, metric_data_key));
        for (int i = 0; i < size; ++i) {
              settings_.setArrayIndex(i);
              QDate d = settings_.value(date_key).toDate();
              QVariant v = settings_.value(value_key);

              switch (dt) {
              case Enums::Boolean:
                  metric.upsertData(d, v.toBool());
                  break;
              case Enums::Integer:
                  metric.upsertData(d, v.toInt());
                  break;
              case Enums::Time:
                  metric.upsertData(d, v.toTime());
                  break;
              default: continue;
              }
          }
          settings_.endArray();

          if (metric.forEachDay()) {
              metric.normalize();
          }
          metrics_.push_back(metric);
    }

    std::sort(metrics_.begin(), metrics_.end(),
              [](const Metric &m1, const Metric &m2){
        return m1.startDate() < m2.startDate();
    });
}

Metric *MetricStorage::metricFamily(const QString &name) const
{
    auto it = std::find_if(metrics_.cbegin(), metrics_.cend(),
                        [&name](const auto &m){
        return !m.name().compare(name, Qt::CaseInsensitive);
    });

    return it == metrics_.cend() ? nullptr
                                 : const_cast<Metric*>(&*it);
}




MetricModel::MetricModel(MetricStorage *ms, QObject *parent) :
    QAbstractListModel(parent), st_(ms) {}

int MetricModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return metricsCount();
}

QVariant MetricModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(index);
    Q_UNUSED(role);

    return {};
}

int MetricModel::metricsCount() const
{
    return st_->metricsCount();
}

int MetricModel::metricType(int row) const
{
    if (row < 0) {
        return -1;
    }

    return st_->metricType(row);
}

bool MetricModel::hasData(int row, int number) const
{
    return st_->data(row, number).isValid();
}

QVariant MetricModel::metricData(int row, int number) const
{
    return st_->data(row, number);
}

QString MetricModel::metricName(int row) const
{
    if (row < 0) {
        return {};
    }

    return st_->metricName(row);
}

QDate MetricModel::metricStartDate(int row) const
{
    if (row < 0) {
        return {};
    }

    return st_->startDate(row);
}

void MetricModel::updateModel()
{
    beginResetModel();
    endResetModel();
}
