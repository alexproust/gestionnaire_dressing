import QtQuick
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

DelegateModel {
    id: modelAdherents

    function update() {
        if (items.count > 0) {
            items.setGroups(0, items.count, "items");
        }

        // Step 1: Filter items
        var visible = [];
        for (var i = 0; i < items.count; ++i) {
            var item = items.get(i);
            if (item.model.modelData.name !== "")
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

    model: api.adherents

    filterOnGroup: "visible"

    groups : [
        DelegateModelGroup {
            name: "visible"
            includeByDefault: true
        }
    ]

    delegate: TileAdherent {
        id: tile
        onTileSelect: {
            windowDetailsAdherent.adherentSelected = items.get(index).model.modelData
            windowDetailsAdherent.visible = true
        }
    }
}
