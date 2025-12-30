#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include "apiclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ApiClient api;
    engine.rootContext()->setContextProperty("api", &api);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QString customPath = "Data";
    QDir dir;
    if(dir.mkpath(QString(customPath))){
        qInfo() << "Default path >> "+engine.offlineStoragePath();
        engine.setOfflineStoragePath(QString(customPath));
        qInfo() << "New path >> "+engine.offlineStoragePath();
    }
    engine.loadFromModule("Gestionnaire_dressing", "Main");
    return app.exec();
}
