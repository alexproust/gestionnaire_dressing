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
    Q_INVOKABLE void loadItem(int id);
    Q_INVOKABLE void addItem();
    Q_INVOKABLE void duplicateItem(QJsonObject item);
    Q_INVOKABLE void updateItem(QJsonObject item);
    Q_INVOKABLE void deleteItem(QString id);
    Q_INVOKABLE void loadAdherents();    

    QVariantList items() const { return m_items; }
    QVariantList adherents() const { return m_adherents; }

signals:
    void itemsChanged();
    void itemChanged(QJsonObject costume);
    void itemLoaded(const QVariantMap &item);
    void itemAdded(int id);
    void adherentsChanged();
    void error(QString message);

private slots:
    void onReplyAdherents(QNetworkReply *reply);

private:
    QNetworkAccessManager m_manager;
    QNetworkAccessManager m_managerAdherent;
    QVariantList m_items;
    QVariantList m_adherents;
};
