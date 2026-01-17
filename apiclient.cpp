#include "apiclient.h"
#include <QDebug>

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_managerAdherent, &QNetworkAccessManager::finished,
            this, &ApiClient::onReplyAdherents);
}

void ApiClient::loadItems()
{
    QNetworkRequest req(QUrl("https://qml-api.galetsjade.workers.dev/costume"));
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

        m_items.clear();
        for (const QJsonValue &v : doc.array())
            m_items.append(v.toObject().toVariantMap());

        emit itemsChanged();
        reply->deleteLater();
    });
}


void ApiClient::addItem()
{
    QNetworkRequest req(QUrl("https://qml-api.galetsjade.workers.dev/costume"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject obj;

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(obj).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QVariant status =
            reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

        QByteArray data = reply->readAll();
        qDebug() << "HTTP status ="
                 << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
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

        qDebug() << "New item id =" << id;
        emit itemAdded(id);

        loadItems();
        reply->deleteLater();
    });
}


void ApiClient::loadItem(int id)
{
    qDebug() << "[ApiClient] loadItem" << id;

    QNetworkRequest req(
        QUrl(QString("https://qml-api.galetsjade.workers.dev/costume/%1").arg(id))
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

        QVariantMap item;
        for (auto it = obj.begin(); it != obj.end(); ++it)
            item[it.key()] = it.value().toVariant();

        emit itemLoaded(item);
        reply->deleteLater();
    });
}

void ApiClient::deleteItem(QString id)
{
    QNetworkRequest req(QUrl(QString("https://qml-api.galetsjade.workers.dev/costume/"+id)));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QNetworkReply *reply = m_manager.deleteResource(req);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            emit error(reply->errorString());
        } else {
            qDebug() << "[ApiClient] delete OK";
            loadItems();   // recharge la liste
        }
        reply->deleteLater();
    });
}

void ApiClient::loadAdherents()
{
    QNetworkRequest req(QUrl("https://qml-api.galetsjade.workers.dev/adherent"));
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
        // qDebug() << "[ApiClient] m_items:" << v.toObject().toVariantMap();
    }

    qDebug() << "[ApiClient] emit adherentsChanged";
    emit adherentsChanged();
    reply->deleteLater();
}
