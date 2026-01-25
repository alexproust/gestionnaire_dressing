import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: windowEmpruntCostume
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
    property var aujourdHui: new Date()
    property string jourNowStr : Qt.formatDate(new Date(), "dd")
    property int jourNow : parseInt(jourNowStr, 10)
    property string moisNowStr : Qt.formatDate(new Date(), "MM")
    property int moisNow : parseInt(moisNowStr, 10)
    property string anneeNowStr : Qt.formatDate(new Date(), "yyyy")
    property int anneeNow : parseInt(anneeNowStr, 10)
    width: parent.width - 800
    height: parent.height - 500
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey100
    signal recordModification()

    onCostumeSelectedChanged:
    {
        if (costumeSelected.id === undefined)
        {
            windowEmpruntCostume.visible = false
        }
        else
        {
            emprunteur = costumeSelected.emprunteur
            const idx = nameSelected.model.findIndex(p => p && p.name === emprunteur)
            if (idx >= 0) nameSelected.currentIndex = idx
            if (costumeSelected.emprunteur)
            {
                let dateEmprunt = splitDate(costumeSelected.date_emprunt)
                if (dateEmprunt)
                {
                    jourEmprunt = dateEmprunt.jour
                    moisEmprunt = dateEmprunt.mois
                    anneeEmprunt = dateEmprunt.annee
                }
            }
            else
            {
                let dateRetour = splitDate(costumeSelected.date_retour)
                if (dateRetour)
                {
                    jourRetour = dateRetour.jour
                    moisRetour = dateRetour.mois
                    anneeRetour = dateRetour.annee
                }
            }
        }
    }

    function splitDate(dateStr) {
        const parts = (dateStr || "").trim().split("/")
        if (parts.length !== 3) return null

        const jour  = parseInt(parts[0], 10)
        const mois  = parseInt(parts[1], 10)
        const annee = parseInt(parts[2], 10)

        if (!Number.isFinite(jour) || !Number.isFinite(mois) || !Number.isFinite(annee))
            return null

        return { jour: jour, mois: mois, annee: annee }
    }

    function formatDate(jourStr, moisStr, anneeStr) {
        const dateStr =  jourStr + "/" + moisStr + "/" + anneeStr
        return dateStr
    }

    onJourEmpruntChanged: { daySelected.currentIndex = jourEmprunt - 1      }
    onMoisEmpruntChanged: { monthSelected.currentIndex = moisEmprunt - 1    }
    onAnneeEmpruntChanged:{ yearSelected.currentIndex = anneeEmprunt - 2024 }

    onJourRetourChanged: { dayReturnSelected.currentIndex = jourRetour - 1      }
    onMoisRetourChanged: { monthReturnSelected.currentIndex = moisRetour - 1    }
    onAnneeRetourChanged:{ yearReturnSelected.currentIndex = anneeRetour - 2024 }

    MouseArea {
        width: parent.width + 800
        height: parent.height + 600
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        z: windowEmpruntCostume.z-1
    }

    Button {
        id: modificationButton
        text: windowEmpruntCostume.editMode ? "Annuler" : "Modifier"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            windowEmpruntCostume.editMode = !windowEmpruntCostume.editMode
        }
    }

    Button {
        id: empruntButton
        text: costumeSelected.emprunteur ? "Rendre" : "Emprunter"
        anchors.left: modificationButton.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (costumeSelected.emprunteur)
            {
                nameSelected.currentIndex = nameSelected.count - 1
                nameSelected.popup.close()
                emprunteur = ""
                jourRetour = jourNow
                moisRetour = moisNow
                anneeRetour = anneeNow
            }
            else
            {
                nameSelected.currentIndex = -1
                jourEmprunt = jourNow
                moisEmprunt = moisNow
                anneeEmprunt = anneeNow
                nameSelected.popup.open()
            }
            windowEmpruntCostume.editMode = true
        }
    }

    Text {
        Layout.fillWidth: true
        text: parseInt(costumeSelected.id,10)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: 16
        font: Fonts.title3
    }

    Button {
        text: windowEmpruntCostume.editMode ? "Sauvegarder" : "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (windowEmpruntCostume.editMode){
                windowEmpruntCostume.editMode = !windowEmpruntCostume.editMode
                costumeSelected.emprunteur = emprunteur
                if (emprunteur){
                    costumeSelected.date_emprunt = formatDate(jourEmprunt, moisEmprunt, anneeEmprunt)
                    costumeSelected.date_retour = ""
                }
                else {
                    costumeSelected.date_retour = formatDate(jourRetour, moisRetour, anneeRetour)
                    costumeSelected.date_emprunt = ""
                }
                windowEmpruntCostume.recordModification()
            }
            else {
                parent.visible = false
            }
        }
    }

    ColumnLayout {
        id: row
        Layout.preferredHeight: parent.height
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        Text {
            id: nameText
            Layout.fillWidth: true
            text: !windowEmpruntCostume.editMode ? "Emprunteur: " + costumeSelected.emprunteur : "Emprunteur: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        ComboBox {
            id: nameSelected
            Layout.fillWidth: true
            visible: windowEmpruntCostume.editMode
            model: api.adherents
            textRole: "name"
            onActivated: (index) => {
                const item = nameSelected.model[index]
                emprunteur = item.name
                console.log("onActivated emprunteur = " + emprunteur)
            }
        }

        Text {
            id: dateEmpruntText
            Layout.fillWidth: true
            text: !windowEmpruntCostume.editMode ? "Date Emprunt: " + costumeSelected.date_emprunt : "Date Emprunt: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: daySelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourEmprunt = currentValue
                }
            }
            ComboBox {
                id: monthSelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisEmprunt = currentValue
                }
            }
            ComboBox {
                id: yearSelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeEmprunt = currentValue
                }
            }
        }
        Text {
            id: dateRetourText
            Layout.fillWidth: true
            text: !windowEmpruntCostume.editMode ? "Date Retour: " + costumeSelected.date_retour : "Date Retour: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: dayReturnSelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourRetour = currentValue
                }
            }
            ComboBox {
                id: monthReturnSelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisRetour = currentValue
                }
            }
            ComboBox {
                id: yearReturnSelected
                Layout.fillWidth: true
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeRetour = currentValue
                }
            }
        }
    }
}
