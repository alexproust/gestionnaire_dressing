import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

import Theme.QUANTUM 1.0

AppliQuantum {
    id: root
    headtitle: qsTr("Gestionnaire dressing")
    title: qsTr("Gestionnaire dressing")
    visible: true
    visibility: Window.Maximized
    property var filterTemplate: ({})

    property JSONLoader filter: JSONLoader {
        source: "file:Data/filter.json"

        onJsonObjectChanged: {
            var filters = jsonObject.filter
            filterTemplate.type = filters.type
            filterTemplate.genre = filters.genre
            filterTemplate.couleur = filters.couleur
            filterTemplate.taille = filters.taille
            filterTemplate.etat = filters.etat
            filterTemplate.mode = filters.mode
            filterTemplateChanged()
        }
    }

    StackLayout {
        id: content
        anchors.fill: parent
        anchors.topMargin: 85
        anchors.margins: 24
        currentIndex: root.headerContainer.header.tabbar.currentIndex

        RowLayout {
            spacing: 12

            FiltersSidebar {
                id: filtersSidebar
                height: parent.height
                Layout.minimumWidth: parent.width*0.25
                Layout.preferredWidth: parent.width*0.25
                Layout.maximumWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true

                spacing: 8

                filter: root.filterTemplate

                onAddSelect: {
                    let rowid = JS.dbInsert()
                    let newId = JS.dbSetId(rowid)
                    windowDetailsCostume.costumeSelected = JS.dbGetCostumeWithId(newId)
                    windowDetailsCostume.visible = true
                    windowDetailsCostume.editMode = true
                    windowDetailsCostume.description = ""
                    modelCostumesFiltered.listModel.update()
                }

                onInStockSelectChanged:     modelCostumesFiltered.inStockSelected =   filtersSidebar.inStockSelect
                onTypeSelectedChanged:      modelCostumesFiltered.typeSelected =      filtersSidebar.typeSelected
                onGenreSelectedChanged:     modelCostumesFiltered.genreSelected =     filtersSidebar.genreSelected
                onCouleurSelectedChanged:   modelCostumesFiltered.couleurSelected =   filtersSidebar.couleurSelected
                onTailleSelectedChanged:    modelCostumesFiltered.tailleSelected =    filtersSidebar.tailleSelected
                onEtatSelectedChanged:      modelCostumesFiltered.etatSelected =      filtersSidebar.etatSelected
                onModeSelectedChanged:      modelCostumesFiltered.modeSelected =      filtersSidebar.modeSelected
            }

            ScrollView {
                Layout.minimumWidth: parent.width*0.5
                Layout.preferredWidth: parent.width*0.6
                Layout.maximumWidth: parent.width
                Layout.preferredHeight: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                GridView {
                    anchors.fill: parent
                    model: modelCostumesFiltered
                    cellWidth: 310; cellHeight: 90
                }
            }
        }

        ScrollView {
            Layout.alignment: Qt.AlignVCenter
            contentWidth: availableWidth
            clip: true
            GridView {
                anchors.fill: parent
                model: modelAdherents
                cellWidth: 310; cellHeight: 90
            }
        }
    }


    ModelCostumesFiltered {
        id: modelCostumesFiltered
    }

    ModelAdherents {
        id: modelAdherents
    }

    WindowDetailsCostume{
        id: windowDetailsCostume
        filter: root.filterTemplate
        onRecordModification: {
            JS.dbUpdate(windowDetailsCostume.costumeSelected);
            modelCostumesFiltered.listModel.update()
        }
        onDeleteCostume: {
            JS.dbDeleteRow(costumeSelected.id)
            windowDetailsCostume.visible = false
            modelCostumesFiltered.listModel.update()
        }
        onDuplicateCostume: {
            let rowid = JS.dbInsert();
            let newId = JS.dbSetCostumeAtRowId(rowid, JS.dbGetCostumeWithId(costumeSelected.id));
            modelCostumesFiltered.listModel.update()
            windowDetailsCostume.costumeSelected = JS.dbGetCostumeWithId(newId)
            windowDetailsCostume.visible = true
            windowDetailsCostume.editMode = true
            windowDetailsCostume.type =  windowDetailsCostume.costumeSelected.type
            windowDetailsCostume.description = windowDetailsCostume.costumeSelected.description
            windowDetailsCostume.genre =  windowDetailsCostume.costumeSelected.genre
            windowDetailsCostume.mode =  windowDetailsCostume.costumeSelected.mode
            windowDetailsCostume.epoque = windowDetailsCostume.costumeSelected.epoque
            windowDetailsCostume.couleur =  windowDetailsCostume.costumeSelected.couleur
            windowDetailsCostume.taille =  windowDetailsCostume.costumeSelected.taille
            windowDetailsCostume.etat =  windowDetailsCostume.costumeSelected.etat
        }
        onEmprunterCostume: {
            windowEmpruntCostume.costumeSelected = windowDetailsCostume.costumeSelected
            windowEmpruntCostume.visible = true
        }
    }

    WindowEmpruntCostume{
        id: windowEmpruntCostume
        aderents: modelAdherents.listModel
        onRecordModification: {
            JS.dbUpdate(costumeSelected);
            modelCostumesFiltered.listModel.update()
        }
    }

    WindowDetailsAdherent{
        id: windowDetailsAdherent
    }

    Component.onCompleted: {
        JS.dbInit()
    }
}
