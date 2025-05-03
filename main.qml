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
                    JS.dbSetId(rowid)
                    visualModel.listModel.update()
                    windowDetailsCostume.costumeSelected = visualModel.listModel.get(0)
                    windowDetailsCostume.visible = true
                    windowDetailsCostume.editMode = true
                    windowDetailsCostume.description = ""
                }

                onInStockSelectChanged:     visualModel.inStockSelected =   filtersSidebar.inStockSelect
                onTypeSelectedChanged:      visualModel.typeSelected =      filtersSidebar.typeSelected
                onGenreSelectedChanged:     visualModel.genreSelected =     filtersSidebar.genreSelected
                onCouleurSelectedChanged:   visualModel.couleurSelected =   filtersSidebar.couleurSelected
                onTailleSelectedChanged:    visualModel.tailleSelected =    filtersSidebar.tailleSelected
                onEtatSelectedChanged:      visualModel.etatSelected =      filtersSidebar.etatSelected
                onModeSelectedChanged:      visualModel.modeSelected =      filtersSidebar.modeSelected
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
                    model: visualModel
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


    SortFilterModel {
        id: visualModel
    }

    ModelAdherents {
        id: modelAdherents
    }

    WindowDetailsCostume{
        id: windowDetailsCostume
        filter: root.filterTemplate
        onRecordModification: {
            JS.dbUpdate(costumeSelected);
        }
        onDeleteCostume: {
            JS.dbDeleteRow(costumeSelected.id)
            windowDetailsCostume.visible = false
            visualModel.listModel.update()
        }
        onDuplicateCostume: {
            let rowid = JS.dbInsert();
            JS.dbSet(rowid, windowDetailsCostume.costumeSelected);
            visualModel.listModel.update()
            windowDetailsCostume.costumeSelected = visualModel.listModel.get(0)
            windowDetailsCostume.visible = true
            windowDetailsCostume.editMode = true
            windowDetailsCostume.description = windowDetailsCostume.costumeSelected.description
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
        }
    }

    WindowDetailsAdherent{
        id: windowDetailsAdherent
    }

    Component.onCompleted: {
        JS.dbInit()
    }
}
