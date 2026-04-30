import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0

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
        function onCostumesChanged() {
            console.log("Update all costumes")
            modelCostumesFiltered.update()
        }
        function onCostumeChanged(costume) {
            console.log("Costume changed:", JSON.stringify(costume))
            windowDetailsCostume.costumeSelected = costume
            windowEmpruntCostume.costumeSelected = costume
        }
        function onAdherentsChanged() {
            console.log("Update all adherants")
            modelAdherents.update()
        }
        function onCostumeLoaded(costume) {
            console.log("Costume loaded:", JSON.stringify(costume))
            windowDetailsCostume.costumeSelected = costume
        }
        function onCostumeAdded(id) {
            console.log("New costume added, id =", id)
            api.loadCostume(id)
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
                    api.addCostume()
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

        ColumnLayout{
            spacing: 12
            Button {
                id : addButton
                text: qsTr("Ajouter")
                onClicked: {
                    windowNewAdherent.visible = true
                }
            }

            ScrollView {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                GridView {
                    anchors.fill: parent
                    model: modelAdherents
                    cellWidth: 310; cellHeight: 90
                }
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
            api.updateCostume(windowDetailsCostume.costumeSelected)
        }
        onDeleteCostume: {
            api.deleteCostume(costumeSelected.id)
            windowDetailsCostume.visible = false
        }
        onDuplicateCostume: {
            api.duplicateCostume(windowDetailsCostume.costumeSelected)
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

    WindowNewAdherent{
        id: windowNewAdherent
        onAddAdherent: {
            console.log("Add new Adherent : ", windowNewAdherent.newAdherent.name)
            api.addAdherent(windowNewAdherent.newAdherent)
            windowNewAdherent.visible = false
        }
    }

    WindowEmpruntCostume{
        id: windowEmpruntCostume
        aderents: modelAdherents
        onRecordModification: {
            api.updateCostume(windowDetailsCostume.costumeSelected)
        }
    }

    Component.onCompleted: {
        api.loadCostumes()
        api.loadAdherents()
    }
}
