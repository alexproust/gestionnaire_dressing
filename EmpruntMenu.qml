import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: empruntMenu
    property string jourEmprunt: ""
    property string moisEmprunt: ""
    property string anneeEmprunt: ""
    property string jourRetour: ""
    property string moisRetour: ""
    property string anneeRetour: ""
    property string emprunteur: ""
    property var costumeSelected: ({})
    property bool editMode: false
    property var aderents: ({})
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
        z: empruntMenu.z-1
    }

    Button {
        id: modificationButton
        text: empruntMenu.editMode ? "Annuler" : "Modifier"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: empruntMenu.editMode = !empruntMenu.editMode
    }

    Button {
        text: empruntMenu.editMode ? "Sauvegarder" : "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (empruntMenu.editMode){
                empruntMenu.editMode = !empruntMenu.editMode
                costumeSelected.emprunteur = emprunteur
                if (emprunteur){
                    costumeSelected.date_emprunt = jourEmprunt + "/" + moisEmprunt + "/" + anneeEmprunt
                    costumeSelected.date_retour = ""
                }
                else {
                    costumeSelected.date_retour = jourRetour + "/" + moisRetour + "/" + anneeRetour
                    costumeSelected.date_emprunt = ""
                }
                empruntMenu.recordModification()
            }
            else {
                parent.visible = false
            }
        }
    }

    ColumnLayout {
        id: row
        Layout.preferredHeight: parent.height
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.top: modificationButton.bottom
        anchors.left: parent.left
        anchors.margins: 60
        spacing: 12

        Text {
            Layout.fillWidth: true
            text: "Identifiant: " + costumeSelected.id
            font: Fonts.subtitle1
        }

        Text {
            id: nameText
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            text: !empruntMenu.editMode ? "Emprunteur: " + costumeSelected.emprunteur : "Emprunteur: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        ComboBox {
            id: nameSelected
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            visible: empruntMenu.editMode
            model: aderents
            onCurrentIndexChanged: {
                console.log("onCurrentIndexChanged " + currentText)
                emprunteur = currentText
            }
            onActivated: {
                console.log("onActivated " +  currentText)
                emprunteur = currentText
            }
            onVisibleChanged: {
                console.log("onVisibleChanged " + costumeSelected.emprunteur)
                currentIndex = indexOfValue(costumeSelected.emprunteur)
            }
        }

        Text {
            id: dateEmpruntText
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            text: !empruntMenu.editMode ? "Date Emprunt: " + costumeSelected.date_emprunt : "Date Emprunt: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: daySelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(jourEmprunt)
                }
            }
            ComboBox {
                id: monthSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(moisEmprunt)
                }
            }
            ComboBox {
                id: yearSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(anneeEmprunt)
                }
            }
        }
        Text {
            id: dateRetourText
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            text: !empruntMenu.editMode ? "Date Retour: " + costumeSelected.date_retour : "Date Retour: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: dayReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(jourRetour)
                }
            }
            ComboBox {
                id: monthReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(moisRetour)
                }
            }
            ComboBox {
                id: yearReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: empruntMenu.editMode && !emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(anneeRetour)
                }
            }
        }
    }
}
