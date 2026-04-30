#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

class ApiClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList costumes READ costumes NOTIFY costumesChanged)
    Q_PROPERTY(QVariantList adherents READ adherents NOTIFY adherentsChanged)
    Q_PROPERTY(QString token READ token WRITE setToken NOTIFY tokenChanged)
    Q_PROPERTY(QString baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)

public:
    explicit ApiClient(QObject *parent = nullptr);

    QString baseUrl() const;
    void setBaseUrl(const QString& v);

    QString token() const;
    void setToken(const QString& v);

    Q_INVOKABLE void loadCostumes();
    Q_INVOKABLE void loadCostume(int id);
    Q_INVOKABLE void addCostume();
    Q_INVOKABLE void duplicateCostume(QJsonObject costume);
    Q_INVOKABLE void updateCostume(QJsonObject costume);
    Q_INVOKABLE void deleteCostume(QString id);
    Q_INVOKABLE void loadAdherents();
    Q_INVOKABLE void addAdherent(QJsonObject adherent);

    QVariantList costumes() const { return m_costumes; }
    QVariantList adherents() const { return m_adherents; }

signals:
    void costumesChanged();
    void costumeChanged(QJsonObject costume);
    void costumeLoaded(const QVariantMap &costume);
    void costumeAdded(int id);
    void adherentsChanged();
    void error(QString message);
    void tokenChanged();
    void baseUrlChanged();

    void requestOk(int httpStatus, QVariantMap json);
    void requestError(int httpStatus, QString message, QString rawBody);

private slots:
    void onReplyAdherents(QNetworkReply *reply);
    void addAuthHeader(QNetworkRequest& req) const;

private:
    QNetworkAccessManager m_manager;
    QNetworkAccessManager m_managerAdherent;
    QVariantList m_costumes;
    QVariantList m_adherents;
    QString m_token;
    QString m_baseUrl;
};
