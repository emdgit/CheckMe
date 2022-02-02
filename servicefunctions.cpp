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

QDate ServiceFunctions::currentDate() const
{
    return QDate::currentDate();
}
