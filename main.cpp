#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQuickStyle>
#include <QQmlContext>

#include "Enums.h"
#include "AppAPI.h"
#include "MetricStorage.h"
#include "SignalNotifier.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    MetricStorage ms;
    SignalNotifier sn;

    ApiEnv env;
    env.metrics = &ms;
    env.notifier = &sn;

    AppAPI api(env);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QQmlApplicationEngine engine;
    qmlRegisterSingletonInstance<AppAPI>("App", 1, 0, "API", &api);
    qmlRegisterUncreatableType<Enums>("AppEnums", 1, 0, "Enums", "");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.rootContext()->setContextProperty("Notifier", &sn);
    engine.load(url);

    QObject::connect(&app, &QGuiApplication::aboutToQuit,
                     &api, &AppAPI::finalize, Qt::DirectConnection);

    return app.exec();
}
