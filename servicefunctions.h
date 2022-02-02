#pragma once

#include <QObject>
#include <QDate>

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
    QDate currentDate() const;

};
