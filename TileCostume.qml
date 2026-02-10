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
                text: parseInt(modelData.id,10)
                font: Fonts.subtitle1
            }

            Text {
                Layout.fillWidth: true
                text: modelData.type ? modelData.type : ""
                font: Fonts.subtitle1
                wrapMode: Text.WordWrap
            }
        }

        RowLayout{
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: modelData.genre ? modelData.genre : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: modelData.taille ? modelData.taille : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: modelData.couleur ? modelData.couleur : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
        }
    }
}
