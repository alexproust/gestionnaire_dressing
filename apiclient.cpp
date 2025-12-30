#include "apiclient.h"
#include <QDebug>

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_manager, &QNetworkAccessManager::finished,
            this, &ApiClient::onReply);
    connect(&m_managerAdherent, &QNetworkAccessManager::finished,
            this, &ApiClient::onReplyAdherents);
}

void ApiClient::loadItems()
{
    QNetworkRequest req(QUrl("https://qml-api.galetsjade.workers.dev/costume"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    m_manager.get(req);
}

void ApiClient::loadAdherents()
{
    QNetworkRequest req(QUrl("https://qml-api.galetsjade.workers.dev/adherent"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    m_managerAdherent.get(req);
}

void ApiClient::onReply(QNetworkReply *reply)
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

    m_items.clear();
    for (const QJsonValue &v : doc.array()) {
        m_items.append(v.toObject().toVariantMap());
        // qDebug() << "[ApiClient] m_items:" << v.toObject().toVariantMap();
    }

    qDebug() << "[ApiClient] emit itemsChanged";
    emit itemsChanged();
    reply->deleteLater();
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
        // qDebug() << "[ApiClient] m_items:" << v.toObject().toVariantMap();
    }

    qDebug() << "[ApiClient] emit adherentsChanged";
    emit adherentsChanged();
    reply->deleteLater();
}
