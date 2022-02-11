#include "servicefunctions.h"

#include <iostream>

bool validate_dates(const QDate &d1, const QDate &d2) noexcept
{
    if (!d1.isValid() || d1.isNull()) {
        std::cout << "dateLess(): date1 is null or invalid" << std::endl;
        return false;
    }

    if (!d2.isValid() || d2.isNull()) {
        std::cout << "dateLess(): date1 is null or invalid" << std::endl;
        return false;
    }

    return true;
}

#define CHECK_DATES(D1, D2) if (!validate_dates(d1, d2)) { return false; }
#define CHECK_DATES_V(D1, D2, V) if (!validate_dates(d1, d2)) { return V; }

ServiceFunctions::ServiceFunctions(QObject *parent)
    : QObject(parent) {}

bool ServiceFunctions::dateEqual(const QDate &d1, const QDate &d2) const noexcept
{
    CHECK_DATES(d1, d2);

    return d1 == d2;
}

bool ServiceFunctions::dateLess(const QDate &d1, const QDate &d2) const noexcept
{
    CHECK_DATES(d1, d2);

    return d1 < d2;
}

bool ServiceFunctions::dateLessEqual(const QDate &d1, const QDate &d2) const noexcept
{
    CHECK_DATES(d1, d2);

    return d1 <= d2;
}

int ServiceFunctions::dateDayDiff(const QDate &d1, const QDate &d2) const noexcept
{
    CHECK_DATES_V(d1, d2, -1);

    return std::abs(d1.daysTo(d2));
}

int ServiceFunctions::currentHour() const noexcept
{
    return currentTime().hour();
}

int ServiceFunctions::currentMinute() const noexcept
{
    const auto min = currentTime().minute();
    return (min / 5) * 5;
}

int ServiceFunctions::clamp(int val, int min, int max) const noexcept
{
    return std::clamp(val, min, max);
}

QDate ServiceFunctions::currentDate() const
{
    return QDate::currentDate();
}

QTime ServiceFunctions::currentTime() const
{
    return QTime::currentTime();
}

QTime ServiceFunctions::makeTime(int h, int m) const
{
    return {h, m};
}
