import QtQuick
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

DelegateModel {
    id: visualModel
    property string typeSelected: ""
    property string genreSelected: ""
    property string couleurSelected: ""
    property string tailleSelected: ""
    property string etatSelected: ""
    property bool inStockSelected: false

    property date currentDate: new Date()

    property alias listModel: listModel

    items.onChanged: update()
    onTypeSelectedChanged: update()
    onGenreSelectedChanged: update()
    onCouleurSelectedChanged: update()
    onTailleSelectedChanged: update()
    onEtatSelectedChanged: update()
    onInStockSelectedChanged: update()

    property var filterAcceptsItem: function(item){
        var returnValue = true ;
        if (inStockSelected) {
            returnValue = item.emprunteur === "";
        }
        if (typeSelected !== ""){
            returnValue = item.type.toUpperCase() === typeSelected;
        }
        if (genreSelected !== ""){
            returnValue = returnValue & (item.genre.toUpperCase() === genreSelected);
        }
        if (couleurSelected !== ""){
            returnValue = returnValue & (item.couleur.toUpperCase() === couleurSelected);
        }
        if (tailleSelected !== ""){
            returnValue = returnValue & (item.taille.toUpperCase() === tailleSelected);
        }
        if (etatSelected !== ""){
            returnValue = returnValue & (item.etat.toUpperCase() === etatSelected);
        }

        return returnValue
    }

    function update() {
        if (items.count > 0) {
            items.setGroups(0, items.count, "items");
        }

        // Step 1: Filter items
        var visible = [];
        for (var i = 0; i < items.count; ++i) {
            var item = items.get(i);
            if (filterAcceptsItem(item.model)) {
                visible.push(item);
            }
        }

        // Step 2: Add all items to the visible group:
        for (i = 0; i < visible.length; ++i) {
            item = visible[i];
            item.inVisible = true;
            if (item.visibleIndex !== i) {
                visibleItems.move(item.visibleIndex, i, 1);
            }
        }
    }


    model : ListModel {
        id: listModel
        Component.onCompleted: {
            listModel.update()
        }

        function update(){
            JS.dbReadAll()
        }
    }

    filterOnGroup: "visible"

    groups : [
        DelegateModelGroup {
            name: "visible"
            includeByDefault: false
        }
    ]

    delegate: TileCostume {
        id: tile
        onTileSelect: {
            demoDetail.costumeSelected = listModel.get(index)
            demoDetail.visible = true
        }
    }
}
