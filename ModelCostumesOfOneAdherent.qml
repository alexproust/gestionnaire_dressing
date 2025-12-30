import QtQuick
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

DelegateModel {
    id: listCostumesBorrowedModel

    property date currentDate: new Date()
    property string adherentName: ""

    items.onChanged: update()
    onAdherentNameChanged: update()

    property var filterAcceptsItem: function(item){
        var returnValue = false ;
        if (adherentName !== "" && item.emprunteur){
            returnValue = item.emprunteur.toUpperCase() === adherentName.toUpperCase();
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
            if (filterAcceptsItem(item.model.modelData)) {
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

    model : api.items

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
            console.log("onTileSelected")
            windowEmpruntCostume.costumeSelected = items.get(index).model.modelData
            windowEmpruntCostume.visible = true
        }
    }
}
