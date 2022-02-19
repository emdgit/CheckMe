#pragma once

#include <QVariant>
#include <QObject>
#include <QDate>

class QQuickItem;

namespace QtCharts {
class QChart;
}

class ServiceFunctions : public QObject
{

    Q_OBJECT

public:
    explicit ServiceFunctions(QObject *parent = nullptr);

    Q_INVOKABLE
    bool dateEqual(const QDate &d1, const QDate &d2) const noexcept;

    Q_INVOKABLE
    bool dateLess(const QDate &d1, const QDate &d2) const noexcept;

    Q_INVOKABLE
    bool dateLessEqual(const QDate &d1, const QDate &d2) const noexcept;

    Q_INVOKABLE
    int dateDayDiff(const QDate &d1, const QDate &d2) const noexcept;

    Q_INVOKABLE
    int currentHour() const noexcept;

    Q_INVOKABLE
    int currentMinute() const noexcept;

    Q_INVOKABLE
    int clamp(int val, int min, int max) const noexcept;

    Q_INVOKABLE
    QDate currentDate() const;

    Q_INVOKABLE
    QTime currentTime() const;

    Q_INVOKABLE
    QTime makeTime(int h, int m) const;

    Q_INVOKABLE
    int extractHours(const QTime &t) const;

    Q_INVOKABLE
    int extractMinutes(const QTime &t) const;

    Q_INVOKABLE
    QString toString(const QVariant &var) const;

    static QtCharts::QChart * findChart(QQuickItem *quickItem);

};
