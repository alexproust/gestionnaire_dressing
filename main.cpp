#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>
#include "apiclient.h"

static QString configFilePath() {
    const QString dir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir().mkpath(dir);
    qInfo() << "Path to config file : " + dir;
    return dir + "/config.ini";
}

static QString loadToken(QString* baseUrlOut) {
    QSettings s(configFilePath(), QSettings::IniFormat);
    s.beginGroup("api");
    const QString baseUrl = s.value("baseUrl", "").toString().trimmed();
    const QString token   = s.value("token", "").toString().trimmed();
    s.endGroup();

    if (baseUrlOut) *baseUrlOut = baseUrl;
    return token;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ApiClient api;
    QString baseUrl;
    QString token = loadToken(&baseUrl);

    if (!baseUrl.isEmpty()) api.setBaseUrl(baseUrl);
    if (!token.isEmpty())   api.setToken(token);

    engine.rootContext()->setContextProperty("api", &api);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Gestionnaire_dressing", "Main");
    return app.exec();
}
