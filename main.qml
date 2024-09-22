import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.LocalStorage
import "Database.js" as JS

import Theme.QUANTUM 1.0

AppliQuantum {
    id: root
    title: "Gestionnaire dressing"
    property var model: ({})
    property var filterTemplate: ({})

    property JSONLoader filter: JSONLoader {
        source: "Data/Appli/Costumes/filter.json"

        onJsonObjectChanged: {
            var filters = jsonObject.filter
            filterTemplate.type = filters.type
            filterTemplate.genre = filters.genre
            filterTemplate.couleur = filters.couleur
            filterTemplate.taille = filters.taille
            filterTemplate.etat = filters.etat
            filterTemplateChanged()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 85
        anchors.margins: 24
        spacing: 12

        Filters { ///< Filters
            id: filters
            height: parent.height
            Layout.minimumWidth: 300
            Layout.preferredWidth: 550
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 8

            rawModel: root.model
            filter: root.filterTemplate

            onAddSelect: {
                let rowid = JS.dbInsert()
                JS.dbUpdate(rowid,"","","","","","","","","","");
                JS.dbReadAll()
                for (var i = 0; i < listModel.count; i++ ) {
                    var key = i;
                    model[key] = {};
                    model[key].id =listModel.get(i).id
                    model[key].type =listModel.get(i).type
                    model[key].description =listModel.get(i).description
                    model[key].genre =listModel.get(i).genre
                    model[key].couleur =listModel.get(i).couleur
                    model[key].taille =listModel.get(i).taille
                }
                modelChanged();
                demoDetail.costumeSelected = Object.values(model)[0]
                demoDetail.visible = true
            }
        }

        ScrollView {
            Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            Flow {
                id: itemFlow
                anchors.fill: parent
                spacing: 24
                clip: true

                Repeater {
                    id: itemRepeter
                    model: Object.keys(filters.filteredModel).length;
                    delegate: DemoTile {
                        costume: Object.values(filters.filteredModel)[index]
                        onTileSelect: {
                            demoDetail.costumeSelected = costume
                            demoDetail.visible = true
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: listModel
        Component.onCompleted: {
            JS.dbReadAll()
            for (var i = 0; i < listModel.count; i++ ) {
                var key = i;
                model[key] = {};
                model[key].id =listModel.get(i).id
                model[key].type =listModel.get(i).type
                model[key].description =listModel.get(i).description
                model[key].genre =listModel.get(i).genre
                model[key].couleur =listModel.get(i).couleur
                model[key].taille =listModel.get(i).taille
            }
            modelChanged();
        }
    }

    DemoDetail{
        id: demoDetail
        filter: root.filterTemplate
        onRecordModification: {
            JS.dbUpdate(
                        costumeSelected.id,
                        costumeSelected.type,
                        costumeSelected.description,
                        costumeSelected.genre,
                        costumeSelected.mode,
                        costumeSelected.epoque,
                        costumeSelected.couleur,
                        costumeSelected.taille,
                        costumeSelected.etat,
                        costumeSelected.emplacement,
                        costumeSelected.emprunteur
                        )
            modelChanged();
        }
    }

    Component.onCompleted: {
        JS.dbInit()
    }
}
