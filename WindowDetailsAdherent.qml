import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: windowDetailsAdherent
    property var costumeSelected: ({})
    property alias modelCostumesOfOneAdherent: modelCostumesOfOneAdherent
    property string jourEmprunt: ""
    property string moisEmprunt: ""
    property string anneeEmprunt: ""
    property string jourRetour: ""
    property string moisRetour: ""
    property string anneeRetour: ""
    property string emprunteur: ""
    property var adherentSelected: ({})
    property bool editMode: false
    width: parent.width - 200
    height: parent.height - 200
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey50
    signal deleteCostume()
    signal duplicateCostume()
    signal emprunterCostume()

    MouseArea {
        width: parent.width + 200
        height: parent.height + 200
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            // parent.visible = false
        }
        z: windowDetailsAdherent.z-1
    }

    Button {
        id: closeButton
        text: "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            parent.visible = false
        }
    }

    ModelCostumesOfOneAdherent {
        id: modelCostumesOfOneAdherent
        adherentName: adherentSelected.name !== undefined ? adherentSelected.name : ""
    }

    ColumnLayout {
        id: row
        anchors.top: closeButton.bottom
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
                model: modelCostumesOfOneAdherent
                cellWidth: 310; cellHeight: 90
            }
        }
    }
}
