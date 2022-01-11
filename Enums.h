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

};
