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
    property var aderentTemplate: ({})

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

    property JSONLoader aderents: JSONLoader {
        source: "file:Data/aderents.json"

        onJsonObjectChanged: {
            var aderents = jsonObject.aderents
            aderentTemplate = aderents
            aderentTemplateChanged()
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

            Filters { ///< Filters
                id: filters
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
                    visualModel.listModel.update()
                    demoDetail.costumeSelected = visualModel.listModel.get(0)
                    demoDetail.visible = true
                    demoDetail.editMode = true
                    demoDetail.description = ""
                }

                onInStockSelectChanged:     visualModel.inStockSelected =   filters.inStockSelect
                onTypeSelectedChanged:      visualModel.typeSelected =      filters.typeSelected
                onGenreSelectedChanged:     visualModel.genreSelected =     filters.genreSelected
                onCouleurSelectedChanged:   visualModel.couleurSelected =   filters.couleurSelected
                onTailleSelectedChanged:    visualModel.tailleSelected =    filters.tailleSelected
                onEtatSelectedChanged:      visualModel.etatSelected =      filters.etatSelected
                onModeSelectedChanged:      visualModel.modeSelected =      filters.modeSelected
            }

            ScrollView {
                Layout.minimumWidth: parent.width*0.5
                Layout.preferredWidth: parent.width*0.6
                Layout.maximumWidth: parent.width
                Layout.preferredHeight: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                GridView {
                    anchors.fill: parent
                    model: visualModel
                    cellWidth: 310; cellHeight: 90
                }
            }
        }

        ScrollView {
            Layout.alignment: Qt.AlignVCenter
            // anchors.fill: parent
            GridView {
                anchors.fill: parent
                model: emprunteurModel
                cellWidth: 300; cellHeight: 80
            }
        }
    }


    SortFilterModel {
        id: visualModel
    }

    EmprunteurModel {
        id: emprunteurModel
        adherents: root.aderentTemplate
    }

    DetailCostume{
        id: demoDetail
        filter: root.filterTemplate
        onRecordModification: {
            JS.dbUpdate(costumeSelected);
        }
        onDeleteCostume: {
            JS.dbDeleteRow(costumeSelected.id)
            demoDetail.visible = false
            visualModel.listModel.update()
        }
        onDuplicateCostume: {
            let rowid = JS.dbInsert();
            JS.dbSet(rowid, demoDetail.costumeSelected);
            visualModel.listModel.update()
            demoDetail.costumeSelected = visualModel.listModel.get(0)
            demoDetail.visible = true
            demoDetail.editMode = true
            demoDetail.description = demoDetail.costumeSelected.description
        }
        onEmprunterCostume: {
            empruntMenu.costumeSelected = demoDetail.costumeSelected
            empruntMenu.visible = true
        }
    }

    // DetailAdherent{
    //     id: detailAdherent
    // }

    EmpruntMenu{
        id: empruntMenu
        aderents: root.aderentTemplate
        onRecordModification: {
            JS.dbUpdate(costumeSelected);
        }
    }

    EmprunteurMenu{
        id: emprunteurMenu
        aderents: root.aderentTemplate
    }

    Component.onCompleted: {
        JS.dbInit()
    }
}
