import QtQuick
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: tile
    width: 300
    height: 80
    signal tileSelect()

    layer.enabled: true

    Component.onCompleted: {
        // console.log("---------->> Tile Adherent completed : " + name )
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            tile.tileSelect();
        }

        onPressed:  {
            parent.color = Colors.blue100;
        }

        onReleased:  {
            if(containsMouse) {
                parent.color = Colors.blue50;
            } else {
                parent.color = Colors.white;
            }
        }

        onContainsMouseChanged: {
            if(containsMouse) {
                parent.color = Colors.blue50;
            } else {
                parent.color = Colors.white;
            }
        }
    }

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout{
            Text {
                Layout.fillWidth: true
                text: modelData.name
                font: Fonts.subtitle2
            }
        }
    }
}
