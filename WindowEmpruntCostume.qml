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
    height: parent.height - 600
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
    }

    MouseArea {
        width: parent.width + 800
        height: parent.height + 600
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            // parent.visible = false
        }
        z: windowEmpruntCostume.z-1
    }

    Button {
        id: modificationButton
        text: windowEmpruntCostume.editMode ? "Annuler" : "Modifier"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (!windowEmpruntCostume.editMode)
            {
                emprunteur = costumeSelected.emprunteur
            }
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
                nameSelected.currentIndex = 0
                dayReturnSelected.currentIndex = jourNow - 1
                monthReturnSelected.currentIndex = moisNow - 1
                yearReturnSelected.currentIndex = anneeNow - 2024
            }
            else
            {
                nameSelected.currentIndex = 1
                daySelected.currentIndex = jourNow - 1
                monthSelected.currentIndex = moisNow - 1
                yearSelected.currentIndex = anneeNow - 2024
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
                    costumeSelected.date_emprunt = jourEmprunt + "/" + moisEmprunt + "/" + anneeEmprunt
                    costumeSelected.date_retour = ""
                }
                else {
                    costumeSelected.date_retour = jourRetour + "/" + moisRetour + "/" + anneeRetour
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
            // Layout.preferredHeight: 64
            text: !windowEmpruntCostume.editMode ? "Emprunteur: " + costumeSelected.emprunteur : "Emprunteur: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        ComboBox {
            id: nameSelected
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            visible: windowEmpruntCostume.editMode
            model: aderents
            onCurrentIndexChanged: {
                emprunteur =  valueAt(currentIndex)
                console.log("onCurrentIndexChanged emprunteur = " + emprunteur)
            }
            onActivated: {
                emprunteur = currentText
                console.log("onActivated emprunteur = " +  currentText)
            }
            onVisibleChanged: {
                currentIndex = indexOfValue(emprunteur)
                console.log("onVisibleChanged emprunteur index = " + currentIndex)
            }
        }

        Text {
            id: dateEmpruntText
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            text: !windowEmpruntCostume.editMode ? "Date Emprunt: " + costumeSelected.date_emprunt : "Date Emprunt: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: daySelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(jourEmprunt)
                }
                onCurrentIndexChanged: {
                    jourEmprunt =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  jourEmprunt)
                }
            }
            ComboBox {
                id: monthSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(moisEmprunt)
                }
                onCurrentIndexChanged: {
                    moisEmprunt =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  moisEmprunt)
                }
            }
            ComboBox {
                id: yearSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeEmprunt = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(anneeEmprunt)
                }
                onCurrentIndexChanged: {
                    anneeEmprunt =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  anneeEmprunt)
                }
            }
        }
        Text {
            id: dateRetourText
            Layout.fillWidth: true
            // Layout.preferredHeight: 64
            text: !windowEmpruntCostume.editMode ? "Date Retour: " + costumeSelected.date_retour : "Date Retour: "
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }
        RowLayout{
            ComboBox {
                id: dayReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    jourRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(jourRetour)
                }
                onCurrentIndexChanged: {
                    jourRetour =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  jourRetour)
                }
            }
            ComboBox {
                id: monthReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    moisRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(moisRetour)
                }
                onCurrentIndexChanged: {
                    moisRetour =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  moisRetour)
                }
            }
            ComboBox {
                id: yearReturnSelected
                Layout.fillWidth: true
                // Layout.preferredHeight: 64
                visible: windowEmpruntCostume.editMode && !emprunteur
                model: ["2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033"]
                onActivated: {
                    console.log("onActivated " +  currentValue)
                    anneeRetour = currentValue
                }
                onVisibleChanged: {
                    currentIndex = indexOfValue(anneeRetour)
                }
                onCurrentIndexChanged: {
                    anneeRetour =  valueAt(currentIndex)
                    console.log("onCurrentIndexChanged " +  anneeRetour)
                }
            }
        }
    }
}
