#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQuickStyle>
#include <QQmlContext>
#include <QIcon>

#include "Enums.h"
#include "AppAPI.h"
#include "MetricStorage.h"
#include "SignalNotifier.h"
#include "servicefunctions.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QIcon::setThemeName("Material");

    MetricStorage ms;
    SignalNotifier sn;

    ApiEnv env;
    env.metrics = &ms;
    env.notifier = &sn;

    AppAPI api(env);
    MetricModel model(&ms);

    ServiceFunctions funcs;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&sn,    &SignalNotifier::registeredNewMetricFamily,
                     &model, &MetricModel::updateModel,
                     Qt::QueuedConnection);

    QObject::connect(&sn,    &SignalNotifier::metricsLoaded,
                     &model, &MetricModel::updateModel,
                     Qt::QueuedConnection);

    QObject::connect(&sn,    &SignalNotifier::removedMetricFamily,
                     &model, &MetricModel::updateModel,
                     Qt::QueuedConnection);

    ms.load();

    QQmlApplicationEngine engine;
    qmlRegisterSingletonInstance<AppAPI>("App", 1, 0, "API", &api);
    qmlRegisterSingletonInstance<MetricModel>("App", 1, 0, "MetricModel", &model);
    qmlRegisterSingletonInstance<ServiceFunctions>("App.Funcs", 1, 0, "Funcs", &funcs);
    qmlRegisterUncreatableType<Enums>("App.Enums", 1, 0, "Enums", "");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    QObject::connect(&engine, &QQmlApplicationEngine::quit,
                     &QGuiApplication::quit);

    engine.rootContext()->setContextProperty("Notifier", &sn);
    engine.load(url);

    QObject::connect(&app, &QGuiApplication::aboutToQuit,
                     &api, &AppAPI::finalize, Qt::DirectConnection);

    return app.exec();
}
