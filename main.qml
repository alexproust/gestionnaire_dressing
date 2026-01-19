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
    property var costumes: ({})

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

    Connections {
        target: api
        function onError(msg) { console.log("API error:", msg) }
        function onItemsChanged() {
            console.log("update")
            modelCostumesFiltered.update()
        }
        function onItemChanged(item) {
            console.log("Item changed:", JSON.stringify(item))
            windowDetailsCostume.costumeSelected = item
        }
        function onAdherentsChanged() {
            modelAdherents.update()
        }
        function onItemLoaded(item) {
            console.log("Item loaded:", JSON.stringify(item))
            windowDetailsCostume.costumeSelected = item
        }
        function onItemAdded(id) {
            console.log("Nouvel item ajouté, id =", id)
            api.loadItem(id)
            windowDetailsCostume.visible = true
            windowDetailsCostume.editMode = true
            windowDetailsCostume.description = ""
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
                    api.addItem()
                }

                onInStockSelectChanged:     modelCostumesFiltered.inStockSelected =   filtersSidebar.inStockSelect
                onTypeSelectedChanged:      modelCostumesFiltered.typeSelected =      filtersSidebar.typeSelected
                onGenreSelectedChanged:     modelCostumesFiltered.genreSelected =     filtersSidebar.genreSelected
                onCouleurSelectedChanged:   modelCostumesFiltered.couleurSelected =   filtersSidebar.couleurSelected
                onTailleSelectedChanged:    modelCostumesFiltered.tailleSelected =    filtersSidebar.tailleSelected
                onEtatSelectedChanged:      modelCostumesFiltered.etatSelected =      filtersSidebar.etatSelected
                onModeSelectedChanged:      modelCostumesFiltered.modeSelected =      filtersSidebar.modeSelected
                onIdSearchChanged:
                {
                    modelCostumesFiltered.idSearch =          filtersSidebar.idSearch
                }
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
            api.updateItem(windowDetailsCostume.costumeSelected)
            // JS.dbUpdate(windowDetailsCostume.costumeSelected);
            // modelCostumesFiltered.listModel.update()
        }
        onDeleteCostume: {
            api.deleteItem(costumeSelected.id)
            windowDetailsCostume.visible = false
        }
        onDuplicateCostume: {
            api.duplicateItem(windowDetailsCostume.costumeSelected)
        }
        onEmprunterCostume: {
            windowEmpruntCostume.costumeSelected = windowDetailsCostume.costumeSelected
            windowEmpruntCostume.visible = true
        }
    }


    WindowDetailsAdherent{
        id: windowDetailsAdherent
        onEmprunterCostume: {
            windowEmpruntCostume.costumeSelected = windowDetailsCostume.costumeSelected
            windowEmpruntCostume.visible = true
        }
    }

    WindowEmpruntCostume{
        id: windowEmpruntCostume
        aderents: modelAdherents.listModel
        onRecordModification: {
            api.updateItem(windowDetailsCostume.costumeSelected)

            costumeSelected = windowDetailsCostume.costumeSelected
            windowDetailsCostume.costumeSelected = costumeSelected
        }
    }

    Component.onCompleted: {
        api.loadItems()
        api.loadAdherents()
    }
}
