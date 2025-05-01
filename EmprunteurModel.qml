import QtQuick
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

DelegateModel {
    id: emprunteurModel
    property var adherents: ({})

    property alias listModel: listEmprunterModel

    items.onChanged: update()

    onAdherentsChanged: {
        listEmprunterModel.update()
    }

    function update() {
        if (items.count > 0) {
            items.setGroups(0, items.count, "items");
        }

        // Step 1: Filter items
        var visible = [];
        for (var i = 0; i < items.count; ++i) {
            var item = items.get(i);
            if (item.model.name !== "")
                console.log(item.model.name + " is != null")
                visible.push(item);
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
        id: listEmprunterModel
        Component.onCompleted: {
            listEmprunterModel.update()
        }

        function update(){
            JS.jsUpdate(adherents)
        }
    }

    filterOnGroup: "visible"

    groups : [
        DelegateModelGroup {
            name: "visible"
            includeByDefault: false
        }
    ]

    delegate: TileAdherent {
        id: tile
        // onTileSelect: {
        //     detailAdherent.adherentSelected = listEmprunterModel.get(index)
        //     detailAdherent.visible = true
        // }
    }
}
