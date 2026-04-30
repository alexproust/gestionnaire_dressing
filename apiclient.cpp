#include "apiclient.h"
#include <QDebug>

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
{
    connect(&m_managerAdherent, &QNetworkAccessManager::finished,
            this, &ApiClient::onReplyAdherents);
}

QString ApiClient::baseUrl() const { return m_baseUrl; }
void ApiClient::setBaseUrl(const QString& v) { m_baseUrl = v; emit baseUrlChanged(); }

QString ApiClient::token() const { return m_token; }

void ApiClient::setToken(const QString& v) {
    m_token = v.trimmed();
    emit tokenChanged();
}

void ApiClient::addAuthHeader(QNetworkRequest& req) const {
    const auto t = m_token.trimmed();
    qDebug() << "Token length =" << t.size() << "bytes";   // doit être 64 pour 32 bytes hex
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());
}

void ApiClient::loadCostumes()
{
    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/costume");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);

    QNetworkReply *reply = m_manager.get(req);
    qDebug() << "[ApiClient] GET URL:" << req.url().toString();
    const auto headers = req.rawHeaderList();
    for (const QByteArray &h : headers) {
        qDebug() << "[ApiClient] Header:" << h << "->" << req.rawHeader(h);
    }
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int http = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (http >= 400)
        {
            emit error(QString("HTTP error %1").arg(http));
            return;
        }
        const QByteArray data = reply->readAll();
        // qDebug() << "HTTP" << http
        //          << "QtError" << reply->error() << reply->errorString()
        //          << "Body" << data;

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

        qDebug() << "[ApiClient] emit costumesChanged";
        emit costumesChanged();
        reply->deleteLater();
    });
}


void ApiClient::addCostume()
{
    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/costume");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);

    QJsonObject obj;

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(obj).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int http = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (http >= 400)
        {
            emit error(QString("HTTP error %1").arg(http));
            return;
        }
        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << http;
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

    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/costume/" + costume["id"].toString());
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);

    QNetworkReply *reply =
        m_manager.put(req, QJsonDocument(costume).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int http = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (http >= 400)
        {
            emit error(QString("HTTP error %1").arg(http));
            return;
        }
        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << http;
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

        // qDebug() << "Update costume =" << costume;
        emit costumeChanged(costume);

        loadCostumes();
        reply->deleteLater();
    });
}

void ApiClient::duplicateCostume(QJsonObject costume)
{
    qDebug() << "[ApiClient] duplicateCostume" << costume;

    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/costume");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(costume).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int http = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (http >= 400)
        {
            emit error(QString("HTTP error %1").arg(http));
            return;
        }
        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << http;
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
        QUrl(QString(m_baseUrl + "/costume/%1").arg(id))
        );
    addAuthHeader(req);

    QNetworkReply *reply = m_manager.get(req);
    qDebug() << "[ApiClient] GET URL:" << req.url().toString();
    const auto headers = req.rawHeaderList();
    for (const QByteArray &h : headers) {
        qDebug() << "[ApiClient] Header:" << h << "->" << req.rawHeader(h);
    }

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
    QNetworkRequest req(QUrl(QString(m_baseUrl + "/costume/"+id)));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);
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
    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/adherent");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);
    m_managerAdherent.get(req);
    qDebug() << "[ApiClient] GET URL:" << req.url().toString();
    const auto headers = req.rawHeaderList();
    for (const QByteArray &h : headers) {
        qDebug() << "[ApiClient] Header:" << h << "->" << req.rawHeader(h);
    }
}

void ApiClient::addAdherent(QJsonObject adherent)
{
    qDebug() << "[ApiClient] addAdherent" << adherent;

    QUrl url = QUrl(m_baseUrl);
    url.setPath(url.path() + "/adherent");
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    addAuthHeader(req);

    QNetworkReply *reply =
        m_manager.post(req, QJsonDocument(adherent).toJson(QJsonDocument::Compact));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int http = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (http >= 400)
        {
            emit error(QString("HTTP error %1").arg(http));
            return;
        }
        QByteArray data = reply->readAll();
        qDebug() << "HTTP status =" << http;
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

        qDebug() << "New adherent id =" << id;
        emit adherentsChanged();

        loadAdherents();
        reply->deleteLater();
    });
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
        // qDebug() << "[ApiClient] adherent:" << v.toObject().toVariantMap();
    }

    qDebug() << "[ApiClient] emit adherentsChanged";

    std::sort(m_adherents.begin(), m_adherents.end(),
              [](const QVariant &a, const QVariant &b) {
                  const auto ma = a.toMap();
                  const auto mb = b.toMap();

                  QString nameA = ma["name"].toString().toLower();
                  QString nameB = mb["name"].toString().toLower();

                  return nameA < nameB;
              });

    emit adherentsChanged();
    reply->deleteLater();
}
