#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>
#include "apiclient.h"
#include <windows.h>
#include <cstdio>

static QString configFilePath() {
    const QString dir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir().mkpath(dir);
    qInfo() << "Path to config file : " + dir;
    return dir + "/config.ini";
}

static QString loadConfig(QString* baseUrlOut) {
    QSettings s(configFilePath(), QSettings::IniFormat);
    s.beginGroup("api");
    const QString baseUrl = s.value("baseUrl", "").toString().trimmed();
    const QString token   = s.value("token", "").toString().trimmed();
    s.endGroup();

    if (baseUrlOut) {
        qInfo() << "URL : " + baseUrl;
        *baseUrlOut = baseUrl;
    }
    qInfo() << "Token : " + token;
    return token;
}

void attachConsole()
{
    AllocConsole();

    FILE* fp;

    freopen_s(&fp, "CONOUT$", "w", stdout);
    freopen_s(&fp, "CONOUT$", "w", stderr);
    freopen_s(&fp, "CONIN$", "r", stdin);
}

int main(int argc, char *argv[])
{
    #ifdef _WIN32
        attachConsole();
    #endif

    qputenv("QT_LOGGING_RULES", "qml.debug=true");
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ApiClient api;
    QString baseUrl;
    QString token = loadConfig(&baseUrl);

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
