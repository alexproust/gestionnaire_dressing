import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

import Theme.QUANTUM 1.0

AppliQuantum {
    id: root
    title: qsTr("Gestionnaire dressing")
    visible: true
    property var model: ({})
    property var filterTemplate: ({})

    property JSONLoader filter: JSONLoader {
        source: "Data/filter.json"

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
                listModel.update()
                demoDetail.costumeSelected = Object.values(model)[0]
                demoDetail.visible = true
                demoDetail.editMode = true
            }

            onFilteredModelChanged: {
                itemRepeter.update()
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
            listModel.update()
        }

        function update(){
            JS.dbReadAll()
            console.log("Udpate database : nb items found : " + listModel.count)
            model = ({})
            for (var i = 0; i < listModel.count; i++ ) {
                var key = i;
                model[key] = {};
                model[key].id =listModel.get(i).id
                model[key].type =listModel.get(i).type
                model[key].description =listModel.get(i).description
                model[key].genre =listModel.get(i).genre
                model[key].mode =listModel.get(i).mode
                model[key].epoque =listModel.get(i).epoque
                model[key].couleur =listModel.get(i).couleur
                model[key].taille =listModel.get(i).taille
                model[key].etat =listModel.get(i).etat
                model[key].emprunteur =listModel.get(i).emprunteur
                model[key].emplacement =listModel.get(i).emplacement
                model[key].date_versement_caution =listModel.get(i).date_versement_caution
                model[key].date_emprunt =listModel.get(i).date_emprunt
                model[key].date_retour =listModel.get(i).date_retour
                model[key].date_remboursement_caution =listModel.get(i).date_remboursement_caution
                model[key].commentaires =listModel.get(i).commentaires
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
        onDeleteCostume: {
            JS.dbDeleteRow(costumeSelected.id)
            demoDetail.visible = false
            listModel.update()
        }
    }

    Component.onCompleted: {
        JS.dbInit()
    }
}
