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
    Q_PROPERTY(QVariantList items READ items NOTIFY itemsChanged)
    Q_PROPERTY(QVariantList adherents READ adherents NOTIFY adherentsChanged)

public:
    explicit ApiClient(QObject *parent = nullptr);

    Q_INVOKABLE void loadItems();
    Q_INVOKABLE void loadAdherents();

    QVariantList items() const { return m_items; }
    QVariantList adherents() const { return m_adherents; }

signals:
    void itemsChanged();
    void adherentsChanged();
    void error(QString message);

private slots:
    void onReply(QNetworkReply *reply);
    void onReplyAdherents(QNetworkReply *reply);

private:
    QNetworkAccessManager m_manager;
    QNetworkAccessManager m_managerAdherent;
    QVariantList m_items;
    QVariantList m_adherents;
};
