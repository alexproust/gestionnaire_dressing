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

public:
    explicit ApiClient(QObject *parent = nullptr);

    Q_INVOKABLE void loadCostumes();
    Q_INVOKABLE void loadCostume(int id);
    Q_INVOKABLE void addCostume();
    Q_INVOKABLE void duplicateCostume(QJsonObject costume);
    Q_INVOKABLE void updateCostume(QJsonObject costume);
    Q_INVOKABLE void deleteCostume(QString id);
    Q_INVOKABLE void loadAdherents();    

    QVariantList costumes() const { return m_costumes; }
    QVariantList adherents() const { return m_adherents; }

signals:
    void costumesChanged();
    void costumeChanged(QJsonObject costume);
    void costumeLoaded(const QVariantMap &costume);
    void costumeAdded(int id);
    void adherentsChanged();
    void error(QString message);

private slots:
    void onReplyAdherents(QNetworkReply *reply);

private:
    QNetworkAccessManager m_manager;
    QNetworkAccessManager m_managerAdherent;
    QVariantList m_costumes;
    QVariantList m_adherents;
};
