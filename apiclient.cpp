#include "apiclient.h"
#include <QDebug>

QString baseUrl = "https://qml-api.galetsjade.workers.dev";

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_managerAdherent, &QNetworkAccessManager::finished,
            this, &ApiClient::onReplyAdherents);
}

void ApiClient::loadCostumes()
{
    QNetworkRequest req(QUrl(baseUrl + "/costume"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_manager.get(req);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const QByteArray data = reply->readAll();

        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
            reply->deleteLater();
            return;
        }

        const QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isArray()) {
            emit error("Invalid JSON");
            reply->deleteLater();
            return;
        }

        m_costumes.clear();
        for (const QJsonValue &v : doc.array())
            m_costumes.append(v.toObject().toVariantMap());

        emit costumesChanged();
        reply->deleteLater();
    });
}


void ApiClient::addCostume()
{
    QNetworkRequest req(QUrl(baseUrl + "/costume"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject obj;

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(obj).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QVariant status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

        QByteArray data = reply->readAll();
        qDebug() << "HTTP status ="
                 << status.toInt();
        qDebug() << "[POST response]" << data;

        if (data.isEmpty()) {
            qWarning() << "Empty response body";
            reply->deleteLater();
            return;
        }

        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isObject()) {
            qWarning() << "Invalid JSON response";
            reply->deleteLater();
            return;
        }

        QJsonObject res = doc.object();

        int id = res["id"].isString()
                     ? res["id"].toString().toInt()
                     : res["id"].toInt();

        qDebug() << "New costume id =" << id;
        emit costumeAdded(id);

        loadCostumes();
        reply->deleteLater();
    });
}

void ApiClient::updateCostume(QJsonObject costume)
{
    qDebug() << "[ApiClient] updateCostume" << costume["id"].toString();

    QNetworkRequest req(QUrl(baseUrl + "/costume/" + costume["id"].toString()));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    // req.setRawHeader("Authorization", ("Bearer " + token).toUtf8());

    QNetworkReply *reply =
        m_manager.put(req, QJsonDocument(costume).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QVariant status =
            reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << status.toInt();
        qDebug() << "[PUT response]" << data;

        if (data.isEmpty()) {
            qWarning() << "Empty response body";
            reply->deleteLater();
            return;
        }

        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isObject()) {
            qWarning() << "Invalid JSON response";
            reply->deleteLater();
            return;
        }

        QJsonObject res = doc.object();

        QJsonObject costume = res["costume"].toObject();

        qDebug() << "Update costume =" << costume;
        emit costumeChanged(costume);

        loadCostumes();
        reply->deleteLater();
    });
}

void ApiClient::duplicateCostume(QJsonObject costume)
{
    qDebug() << "[ApiClient] duplicateCostume" << costume;

    QNetworkRequest req(QUrl(baseUrl + "/costume"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(costume).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QVariant status =
            reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << status.toInt();
        qDebug() << "[POST response]" << data;

        if (data.isEmpty()) {
            qWarning() << "Empty response body";
            reply->deleteLater();
            return;
        }

        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
            reply->deleteLater();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isObject()) {
            qWarning() << "Invalid JSON response";
            reply->deleteLater();
            return;
        }

        QJsonObject res = doc.object();

        int id = res["id"].isString()
                     ? res["id"].toString().toInt()
                     : res["id"].toInt();

        qDebug() << "New costume id =" << id;
        emit costumeAdded(id);

        loadCostumes();
        reply->deleteLater();
    });
}

void ApiClient::loadCostume(int id)
{
    qDebug() << "[ApiClient] loadCostume" << id;

    QNetworkRequest req(
        QUrl(QString(baseUrl + "/costume/%1").arg(id))
        );

    QNetworkReply *reply = m_manager.get(req);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
            reply->deleteLater();
            return;
        }

        QJsonObject obj =
            QJsonDocument::fromJson(reply->readAll()).object();

        QVariantMap costume;
        for (auto it = obj.begin(); it != obj.end(); ++it)
            costume[it.key()] = it.value().toVariant();

        emit costumeLoaded(costume);
        reply->deleteLater();
    });
}

void ApiClient::deleteCostume(QString id)
{
    QNetworkRequest req(QUrl(QString(baseUrl + "/costume/"+id)));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QNetworkReply *reply = m_manager.deleteResource(req);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
        } else {
            qDebug() << "[ApiClient] delete OK";
            loadCostumes();   // recharge la liste
        }
        reply->deleteLater();
    });
}

void ApiClient::loadAdherents()
{
    QNetworkRequest req(QUrl(baseUrl + "/adherent"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    m_managerAdherent.get(req);
}

void ApiClient::onReplyAdherents(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        emit error(reply->errorString());
        reply->deleteLater();
        return;
    }

    const QByteArray data = reply->readAll();
    const QJsonDocument doc = QJsonDocument::fromJson(data);

    if (!doc.isArray()) {
        emit error("Invalid JSON");
        reply->deleteLater();
        return;
    }

    m_adherents.clear();
    for (const QJsonValue &v : doc.array()) {
        m_adherents.append(v.toObject().toVariantMap());
        qDebug() << "[ApiClient] m_costumes:" << v.toObject().toVariantMap();
    }

    qDebug() << "[ApiClient] emit adherentsChanged";
    emit adherentsChanged();
    reply->deleteLater();
}
