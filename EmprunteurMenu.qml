import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: emprunteurMenu
    property string jourEmprunt: ""
    property string moisEmprunt: ""
    property string anneeEmprunt: ""
    property string jourRetour: ""
    property string moisRetour: ""
    property string anneeRetour: ""
    property string emprunteur: ""
    property var adherentSelected: ({})
    property bool editMode: false
    width: parent.width - 400
    height: parent.height - 400
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey100
    signal recordModification()
    signal deleteCostume()
    signal duplicateCostume()
    signal emprunterCostume()

    MouseArea {
        width: parent.width + 400
        height: parent.height + 400
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            // parent.visible = false
        }
        z: emprunteurMenu.z-1
    }

    Button {
        id: modificationButton
        text: emprunteurMenu.editMode ? "Annuler" : "Modifier"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: emprunteurMenu.editMode = !emprunteurMenu.editMode
    }

    Button {
        text: emprunteurMenu.editMode ? "Sauvegarder" : "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (emprunteurMenu.editMode){
                emprunteurMenu.editMode = !emprunteurMenu.editMode
                adherentSelected.emprunteur = emprunteur
                if (emprunteur){
                    adherentSelected.date_emprunt = jourEmprunt + "/" + moisEmprunt + "/" + anneeEmprunt
                    adherentSelected.date_retour = ""
                }
                else {
                    adherentSelected.date_retour = jourRetour + "/" + moisRetour + "/" + anneeRetour
                    adherentSelected.date_emprunt = ""
                }
                emprunteurMenu.recordModification()
            }
            else {
                parent.visible = false
            }
        }
    }

    CostumesBorrowedModel {
        id: listCostumeEmpruntModel
        adherentName: adherentSelected.name !== undefined ? adherentSelected.name : ""
    }

    ColumnLayout {
        id: row
        anchors.top: modificationButton.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 60
        spacing: 12

        Text {
            Layout.fillWidth: true
            text: "Emprunteur: " + adherentSelected.name
            font: Fonts.subtitle1
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            GridView {
                anchors.fill: parent
                snapMode: GridView.SnapOneRow
                model: listCostumeEmpruntModel
                cellWidth: 310; cellHeight: 90
            }
        }
    }
}
