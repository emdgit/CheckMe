#pragma once

#include <QObject>

class Enums : public QObject
{

    Q_GADGET

public:
    explicit Enums(QObject *parent = nullptr);

    enum MetricDataType {
        Boolean,
        Integer,
        Time
    };
    Q_ENUM(MetricDataType)

    enum MetricDailyType {
        /// Требовать заполненя для каждого дня.
        MDT_EveryDay,
        /// Может содержать дни без данных. (По-умолчанию).
        MDT_Free
    };
    Q_ENUM(MetricDailyType)

    enum NewMetricCardEnums {
        /// Пояснение выбора логического типа.
        NMCE_QuestionBool,
        /// Пояснение выбора целочисленного типа.
        NMCE_QuestionInt,
        /// Пояснение выбора типа времени.
        NMCE_QuestionTime,
        /// Пояснение настройки "Требовать на каждый день".
        NMCE_QuestionEachDay
    };
    Q_ENUM(NewMetricCardEnums)

};
