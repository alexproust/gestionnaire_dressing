import QtQuick

import QtQuick.Layouts

// import QtGraphicalEffects 1.15
import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: tile
    width: 260
    height: 280

    signal tileSelect()

    property var costume: ({})

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
                text: costume.id
                font: Fonts.subtitle1
            }

            Text {
                Layout.fillWidth: true
                text: costume.type ?  costume.type : ""
                font: Fonts.subtitle1
                wrapMode: Text.WordWrap
            }
        }

        FileValidator {
            id: validator
            url: "file:Data/Photos/" + costume.id + ".png"
            treatAsImage: true
        }

        Image {
            Layout.preferredHeight: 2* tile.height / 3
            Layout.maximumWidth: tile.width
            Layout.fillWidth: true
            // Layout.leftMargin: -col.anchors.leftMargin
            Layout.alignment: verticalAlignment
            fillMode: Image.PreserveAspectFit
            source: validator.fileValid ? validator.url : "file:Data/Photos/Pas-dimage-disponible.jpg"
        }

        RowLayout{
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costume.genre ? costume.genre : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costume.taille ? costume.taille : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costume.couleur ? costume.couleur : ""
                font: Fonts.body2
                wrapMode: Text.WordWrap
            }
        }
    }
}
