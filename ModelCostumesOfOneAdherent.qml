import QtQuick
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

DelegateModel {
    id: listCostumesBorrowedModel

    property date currentDate: new Date()
    property string adherentName: ""

    property alias listModel: modelCostumesOfOneAdherent

    items.onChanged: update()
    onAdherentNameChanged: modelCostumesOfOneAdherent.update()

    property var filterAcceptsItem: function(item){
        var returnValue = true ;
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
        id: modelCostumesOfOneAdherent
        // Component.onCompleted: {
        //     modelCostumesOfOneAdherent.update()
        // }

        function update(){
            JS.getListOfCostumeOfAdherent(adherentName)
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
        // onTileSelect: {
        //     demoDetail.costumeSelected = listModel.get(index)
        //     demoDetail.visible = true
        // }
    }
}
