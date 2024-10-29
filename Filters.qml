import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Theme.QUANTUM 1.0
    
ColumnLayout {
    spacing: 12
    property var filter: ({})
    property var locale: Qt.locale()
    property date currentDate: new Date()

    property string typeSelected: ""
    property string genreSelected: ""
    property string couleurSelected: ""
    property string tailleSelected: ""
    property string etatSelected: ""
    property bool inStockSelect: false

    signal addSelect()

    onFilterChanged: {
        if (filter.type)    filterRepeaterType.model = filter.type.length
        if (filter.genre)   filterRepeaterGenre.model = filter.genre.length
        if (filter.couleur) filterRepeaterCouleur.model = filter.couleur.length
        if (filter.taille)  filterRepeaterTaille.model = filter.taille.length
        if (filter.etat)    filterRepeaterEtat.model = filter.etat.length
    }

    function customFilter() {
        typeSelected = ""
        for(var i = 0; i < filterRepeaterType.count; i++ ) {
            if(filterRepeaterType.itemAt(i).isSelected) {
                typeSelected = filterRepeaterType.itemAt(i).text.toUpperCase()
                console.debug(typeSelected + " selected")
            }
        }
        genreSelected = ""
        for(i = 0; i < filterRepeaterGenre.count; i++ ) {
            if(filterRepeaterGenre.itemAt(i).isSelected) {
                genreSelected = filterRepeaterGenre.itemAt(i).text.toUpperCase()
                console.debug(genreSelected + " selected")
            }
        }
        couleurSelected = ""
        for(i = 0; i < filterRepeaterCouleur.count; i++ ) {
            if(filterRepeaterCouleur.itemAt(i).isSelected) {
                couleurSelected = filterRepeaterCouleur.itemAt(i).text.toUpperCase()
                console.debug(couleurSelected + " selected")
            }
        }
        tailleSelected = ""
        for(i = 0; i < filterRepeaterTaille.count; i++ ) {
            if(filterRepeaterTaille.itemAt(i).isSelected) {
                tailleSelected = filterRepeaterTaille.itemAt(i).text.toUpperCase()
                console.debug(tailleSelected + " selected")
            }
        }
        etatSelected = ""
        for(i = 0; i < filterRepeaterEtat.count; i++ ) {
            if(filterRepeaterEtat.itemAt(i).isSelected) {
                etatSelected = filterRepeaterEtat.itemAt(i).text.toUpperCase()
                console.debug(etatSelected + " selected")
            }
        }
    }

    RowLayout{
        Tag {
            id : inStockSwitch
            text: qsTr("Produit en stock")
            onClicked: {
                inStockSelect = inStockSwitch.isSelected
            }
        }

        Button {
            id : addButton
            text: qsTr("Ajouter")
            onClicked: {
                addSelect();
            }
        }
    }

    Text {
        text: "Type"
        font: Fonts.subtitle2
        color: Colors.blue600
    }

    ScrollView {
        Layout.minimumHeight: 200
        Layout.preferredHeight: 270
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: availableWidth
        Flow {
            anchors.fill: parent
            spacing: 3
            Repeater{
                id: filterRepeaterType
                model: 0
                delegate: Tag {
                    text: filter.type[index]
                    onClicked: {
                        customFilter();
                    }
                }
            }
        }
    }

    Text {
        text: "Genre"
        font: Fonts.subtitle2
        color: Colors.blue600
    }

    ScrollView {
        Layout.minimumHeight: 70
        Layout.preferredHeight: 80
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: availableWidth
        Flow {
            anchors.fill: parent
            spacing: 3
            Repeater{
                id: filterRepeaterGenre
                model: 0
                delegate: Tag {
                    text: filter.genre[index]
                    onClicked: {
                        customFilter();
                    }
                }
            }
        }
    }


    Text {
        text: "Couleur"
        font: Fonts.subtitle2
        color: Colors.blue600
    }

    ScrollView {
        Layout.minimumHeight: 90
        Layout.preferredHeight: 210
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: availableWidth
        Flow {
            anchors.fill: parent
            spacing: 3
            Repeater{
                id: filterRepeaterCouleur
                model: 0
                delegate: Tag {
                    text: filter.couleur[index]
                    onClicked: {
                        customFilter();
                    }
                }
            }
        }
    }

    Text {
        text: "Taille"
        font: Fonts.subtitle2
        color: Colors.blue600
    }

    ScrollView {
        Layout.minimumHeight: 100
        Layout.preferredHeight: 140
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: availableWidth
        Flow {
            anchors.fill: parent
            spacing: 3
            Repeater{
                id: filterRepeaterTaille
                model: 0
                delegate: Tag {
                    text: filter.taille[index]
                    onClicked: {
                        customFilter();
                    }
                }
            }
        }
    }

    Text {
        text: "Etat"
        font: Fonts.subtitle2
        color: Colors.blue600
    }

    ScrollView {
        Layout.minimumHeight: 50
        Layout.preferredHeight: 150
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: availableWidth
        Flow {
            anchors.fill: parent
            spacing: 3
            Repeater{
                id: filterRepeaterEtat
                model: 0
                delegate: Tag {
                    text: filter.etat[index]
                    onClicked: {
                        customFilter();
                    }
                }
            }
        }
    }
}
