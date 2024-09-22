import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Theme.QUANTUM 1.0
    
ColumnLayout {
    spacing: 12
    property var rawModel: ({})
    property var filteredModel: ({})
    property var filter: ({})
    property var locale: Qt.locale()
    property date currentDate: new Date()
    onRawModelChanged: customFilter();

    signal addSelect()

    onFilterChanged: {
        if (filter.type)
        {
            console.log(filter.type)
            filterRepeaterType.model = filter.type.length;
        }
        if (filter.genre)
        {
            console.log(filter.genre)
            filterRepeaterGenre.model = filter.genre.length;
        }
        if (filter.couleur)
        {
            console.log(filter.couleur)
            filterRepeaterCouleur.model = filter.couleur.length;
        }
        if (filter.taille)
        {
            console.log(filter.taille)
            filterRepeaterTaille.model = filter.taille.length;
        }
        if (filter.etat)
        {
            console.log(filter.etat)
            filterRepeaterEtat.model = filter.etat.length;
        }
    }

    function customFilter() {
        filteredModel = rawModel;
        filteredModel = Object.values(filteredModel).filter(function(obj) {
            if (inStockSwitch.isSelected) {
                console.info("show in stock articles")
                var date_emprunt = Date.fromLocaleDateString(Qt.locale(), obj.date_emprunt,Locale.ShortFormat)
                print("Date emprunt : " + date_emprunt)
                var date_retour = Date.fromLocaleDateString(Qt.locale(), obj.date_retour,Locale.ShortFormat)
                print("Date retour : " + date_retour)
                // if (obj.date_emprunt === undefined && Date.fromLocaleDateString(obj.date_emprunt) !== filterRepeaterType.itemAt(i).text) {
                //         console.info("pas de " + filterRepeaterType.itemAt(i).text + " sur " + obj.id)
                //         return false;
                // }
                print("Current date : " + currentDate)
                print(date_emprunt<currentDate)
                print(date_emprunt>currentDate)
                if (currentDate<date_retour) {
                    return false;
                }
            }
            else {
                // console.info("show all articles")
            }
            for(var i = 0; i < filterRepeaterType.count; i++ ) {
                if(filterRepeaterType.itemAt(i).isSelected) {
                    console.info(filterRepeaterType.itemAt(i).text + " selected")
                    if( obj.type.toUpperCase().trim() !== filterRepeaterType.itemAt(i).text.toUpperCase()) {
                        console.info(obj.id + "(" + obj.type.toUpperCase().trim() + " pas de type " + filterRepeaterType.itemAt(i).text.toUpperCase())
                        return false;
                    }
                    else {
                        console.info(obj.id + " de type " + filterRepeaterType.itemAt(i).text.toUpperCase())
                    }
                }
            }
            for(var i = 0; i < filterRepeaterGenre.count; i++ ) {
                if(filterRepeaterGenre.itemAt(i).isSelected) {
                    console.info(filterRepeaterGenre.itemAt(i).text + " selected")
                    console.info(obj.genre)
                    if (obj.genre === undefined || obj.genre !== filterRepeaterGenre.itemAt(i).text) {
                        console.info("pas de " + filterRepeaterGenre.itemAt(i).text + " sur " + obj.id)
                        return false;
                    }
                }
            }
            for(var i = 0; i < filterRepeaterCouleur.count; i++ ) {
                if(filterRepeaterCouleur.itemAt(i).isSelected) {
                    console.info(filterRepeaterCouleur.itemAt(i).text + " selected")
                    console.info(obj.genre)
                    if (obj.color === undefined || obj.color !== filterRepeaterCouleur.itemAt(i).text) {
                        console.info("pas de " + filterRepeaterCouleur.itemAt(i).text + " sur " + obj.id)
                        return false;
                    }
                }
            }
            for(var i = 0; i < filterRepeaterTaille.count; i++ ) {
                if(filterRepeaterTaille.itemAt(i).isSelected) {
                    console.info(filterRepeaterTaille.itemAt(i).text + " selected")
                    console.info(obj.genre)
                    if (obj.taille === undefined || obj.taille !== filterRepeaterTaille.itemAt(i).text) {
                        console.info("pas de " + filterRepeaterTaille.itemAt(i).text + " sur " + obj.id)
                        return false;
                    }
                }
            }
            for(var i = 0; i < filterRepeaterEtat.count; i++ ) {
                if(filterRepeaterEtat.itemAt(i).isSelected) {
                    console.info(filterRepeaterEtat.itemAt(i).text + " selected")
                    console.info(obj.genre)
                    if (obj.etat === undefined || obj.etat !== filterRepeaterEtat.itemAt(i).text) {
                        console.info("pas de " + filterRepeaterEtat.itemAt(i).text + " sur " + obj.id)
                        return false;
                    }
                }
            }
            return true;
        })

        filteredModelChanged();

    }

    RowLayout{
        Tag {
        id : inStockSwitch
        text: qsTr("Produit en stock")
        onClicked: {
            customFilter();
        }
    }

        Tag {
            id : addButton
            text: qsTr("Ajouter")
            onClicked: {
                addButton.isSelected = false
                addSelect();
            }
        }
    }

    Text {
        text: "Type"
        font: Fonts.body1
        color: Colors.blue600
    }

    Flow {
        Layout.minimumHeight: 200
        Layout.preferredHeight: 270
        Layout.fillWidth: true
        Layout.fillHeight: true
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

    Text {
        text: "Genre"
        font: Fonts.body1
        color: Colors.blue600
    }

    Flow {
        Layout.minimumHeight: 65
        Layout.preferredHeight: 80
        Layout.fillWidth: true
        Layout.fillHeight: true
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

    Text {
        text: "Couleur"
        font: Fonts.body1
        color: Colors.blue600
    }

    Flow {
        Layout.minimumHeight: 170
        Layout.preferredHeight: 210
        Layout.fillWidth: true
        Layout.fillHeight: true
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

    Text {
        text: "Taille"
        font: Fonts.body1
        color: Colors.blue600
    }

    Flow {
        Layout.minimumHeight: 100
        Layout.preferredHeight: 140
        Layout.fillWidth: true
        Layout.fillHeight: true
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

    Text {
        text: "Etat"
        font: Fonts.body1
        color: Colors.blue600
    }

    Flow {
        Layout.minimumHeight: 50
        Layout.preferredHeight: 150
        Layout.fillWidth: true
        Layout.fillHeight: true
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
