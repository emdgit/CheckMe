#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include "AppAPI.h"
#include "MetricStorage.h"
#include "SignalNotifier.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");

    MetricStorage ms;
    SignalNotifier sn;

    ApiEnv env;
    env.metrics = &ms;
    env.notifier = &sn;

    AppAPI api(env);

    QString name = "My Metric";
    QDate date = QDate::currentDate().addDays(-3);

    ms.registerNewFamily(name);
    ms.upsertValue(name, date, 42); date = date.addDays(1);
    ms.upsertValue(name, date, 142); date = date.addDays(1);
    ms.upsertValue(name, date, 1042);

    name = "Another one";
    date = date.addDays(-3);

    ms.registerNewFamily(name);
    ms.upsertValue(name, date, 10); date = date.addDays(1);
    ms.upsertValue(name, date, 100); date = date.addDays(1);
    ms.upsertValue(name, date, 1000);

    ms.save();
    ms.load();

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
