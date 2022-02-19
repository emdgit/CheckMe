#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QApplication>
#include <QQuickStyle>
#include <QQmlContext>
#include <QIcon>

#include "enums.h"
#include "appapi.h"
#include "metricstorage.h"
#include "signalnotifier.h"
#include "servicefunctions.h"
#include "chartmanager.h"


#include <QtCharts/QAbstractSeries>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QIcon::setThemeName("Material");


    if (QFontDatabase::addApplicationFont("D:\\emdgit\\CheckMe\\font\\Roboto\\Roboto-Thin.ttf") == -1) {
        qDebug("Can't load font family");
    }

    const std::vector<std::string> fonts = {
        "Roboto-Black",
        "Roboto-BlackItalic",
        "Roboto-Bold",
        "Roboto-BoldItalic",
        "Roboto-Italic",
        "Roboto-Light",
        "Roboto-LightItalic",
        "Roboto-Medium",
        "Roboto-MediumItalic",
        "Roboto-Regular",
        "Roboto-Thin",
        "Roboto-ThinItalic"
    };

    for (const auto &f : fonts) {
        const std::string prefix = "D:\\emdgit\\CheckMe\\font\\Roboto\\";
        const std::string font = prefix + f + ".ttf";

        if (QFontDatabase::addApplicationFont(QString::fromStdString(font)) == -1) {
            qDebug() << "Cannot add font family " << QString::fromStdString(f);
        }
    }

    MetricStorage ms;
    SignalNotifier sn;
    ChartManager cm{&ms};

    ApiEnv env;
    env.metrics = &ms;
    env.notifier = &sn;
    env.charts = &cm;

    AppAPI api(env);
    MetricModel model(&ms);

    ServiceFunctions funcs;

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

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
