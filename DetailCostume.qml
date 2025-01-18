import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: demoDetail
    property var costumeSelected: ({})
    property string type: ""
    property string description: ""
    property string genre: ""
    property string mode: ""
    property string epoque: ""
    property string couleur: ""
    property string taille: ""
    property string etat: ""
    property string emplacement: ""
    property bool editMode: false
    property var filter: ({})
    width: parent.width - 100
    height: parent.height - 100
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey50
    signal recordModification()
    signal deleteCostume()
    signal duplicateCostume()
    signal emprunterCostume()

    MouseArea {
        width: parent.width + 100
        height: parent.height + 100
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            // parent.visible = false
        }
        z: demoDetail.z-1
    }

    FileValidator {
        id: validator
        url: "file:Data/Photos/" + costumeSelected.id + ".png"
        treatAsImage: true
    }

    Button {
        id: modificationButton
        text: demoDetail.editMode ? "Annuler" : "Modifier"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (!demoDetail.editMode){
                demoDetail.type = costumeSelected.type
                demoDetail.genre = costumeSelected.genre
                demoDetail.couleur = costumeSelected.couleur
                demoDetail.etat = costumeSelected.etat
                demoDetail.taille = costumeSelected.taille
                demoDetail.description = costumeSelected.description
            }
            demoDetail.editMode = !demoDetail.editMode
        }
    }

    Button {
        id: suppressionButton
        text: "Supprimer"
        anchors.left: modificationButton.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            demoDetail.deleteCostume()
        }
    }

    Button {
        id: duplicateButton
        text: "Dupliquer"
        anchors.left: suppressionButton.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            demoDetail.duplicateCostume()
        }
    }

    Button {
        id: emprunterButton
        text: "Emprunter"
        anchors.left: duplicateButton.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            demoDetail.emprunterCostume()
        }
    }

    Button {
        text: demoDetail.editMode ? "Sauvegarder" : "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            if (demoDetail.editMode){
                costumeSelected.type = demoDetail.type
                costumeSelected.genre = demoDetail.genre
                costumeSelected.couleur = demoDetail.couleur
                costumeSelected.etat = demoDetail.etat
                costumeSelected.taille = demoDetail.taille
                costumeSelected.description = demoDetail.description
                demoDetail.recordModification()
                demoDetail.editMode = !demoDetail.editMode
            }
            else {
                parent.visible = false
            }
        }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Image {
            id: itemImage
            Layout.preferredHeight: 0.75 * row.height
            Layout.preferredWidth: row.width / 2
            Layout.margins: -col.anchors.leftMargin
            fillMode: Image.PreserveAspectFit
            source: validator.fileValid ? validator.url : "file:Data/Photos/Pas-dimage-disponible.jpg"
        }

        ColumnLayout {
            id: col
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            Text {
                Layout.fillWidth: true
                text: "Identifiant: " + costumeSelected.id
                font: Fonts.subtitle1
            }

            RowLayout {
                Text {
                    id: typeText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Type: " + costumeSelected.type : "Type: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }
                ComboBox {
                    id: typeSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.type
                    // onCurrentIndexChanged: {
                    //     console.log("onCurrentIndexChanged " +  filter.type[currentIndex])
                    //     type = filter.type[currentIndex]
                    // }
                    onActivated: {
                        demoDetail.type = filter.type[currentIndex]
                        console.log("onActivated " +  demoDetail.type)
                    }
                    onVisibleChanged: {
                        currentIndex = indexOfValue(costumeSelected.type)
                    }
                }
            }

            RowLayout {
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Description: " + costumeSelected.description : "Description: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }
                TextArea {
                    id: descriptionInput
                    text: description
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    onTextChanged: {
                        description = text
                    }
                }
            }

            RowLayout {
                Text {
                    id: genreText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Genre: " + costumeSelected.genre : "Genre: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }

                ComboBox {
                    id: genreSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.genre
                    // onCurrentIndexChanged: {
                    //     costumeSelected.genre = filter.genre[currentIndex]
                    // }
                    onActivated: {
                        genre = filter.genre[currentIndex]
                        console.log("onActivated " +  genre)
                    }
                    onVisibleChanged: {
                        currentIndex = indexOfValue(costumeSelected.genre)
                    }
                }
            }

            RowLayout {
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Mode: " + costumeSelected.mode : "Mode: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }
                TextField {
                    id: modeInput
                    text: costumeSelected.mode ? costumeSelected.mode : ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    onTextChanged: {
                        costumeSelected.mode = text
                    }
                }
            }

            RowLayout {
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Epoque: " + costumeSelected.epoque : "Epoque: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }
                TextField {
                    id: epoqueInput
                    text: costumeSelected.epoque ? costumeSelected.epoque : ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    onTextChanged: {
                        costumeSelected.epoque = text
                    }
                }
            }

            RowLayout {
                Text {
                    id: couleurText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Couleur: " + costumeSelected.couleur : "Couleur: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }

                ComboBox {
                    id: couleurSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.couleur
                    // onCurrentIndexChanged: {
                    //     costumeSelected.couleur = filter.couleur[currentIndex]
                    // }
                    onActivated: {
                        couleur = filter.couleur[currentIndex]
                        console.log("onActivated " +  couleur)
                    }
                    onVisibleChanged: {
                        currentIndex = indexOfValue(costumeSelected.couleur)
                    }
                }
            }

            RowLayout {
                Text {
                    id: tailleText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Taille: " + costumeSelected.taille : "Taille: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }

                ComboBox {
                    id: tailleSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.taille
                    // onCurrentIndexChanged: {
                    //     costumeSelected.taille = filter.taille[currentIndex]
                    // }
                    onActivated: {
                        taille = filter.taille[currentIndex]
                        console.log("onActivated " +  taille)
                    }
                    onVisibleChanged: {
                        currentIndex = indexOfValue(costumeSelected.taille)
                    }
                }
            }

            RowLayout {
                Text {
                    id: etatText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Etat: " + costumeSelected.etat : "Etat: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }

                ComboBox {
                    id: etatSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.etat
                    // onCurrentIndexChanged: {
                    //     costumeSelected.etat = filter.etat[currentIndex]
                    // }
                    onActivated: {
                        etat = filter.etat[currentIndex]
                        console.log("onActivated " +  etat)
                    }
                    onVisibleChanged: {
                        currentIndex = indexOfValue(costumeSelected.etat)
                    }
                }
            }

            // RowLayout {
            //     Text {
            //         Layout.fillWidth: true
            //         Layout.preferredHeight: 64
            //         text: !demoDetail.editMode ? "Emplacement: " + costumeSelected.emplacement : "Emplacement: "
            //         font: Fonts.body1
            //         wrapMode: Text.WordWrap
            //     }
            //     TextField {
            //         id: placementInput
            //         text: costumeSelected.emplacement ? costumeSelected.emplacement : ""
            //         Layout.fillWidth: true
            //         Layout.preferredHeight: 64
            //         visible: demoDetail.editMode
            //         onTextChanged: {
            //             costumeSelected.emplacement = text
            //         }
            //     }
            // }

            RowLayout {
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: costumeSelected.emprunteur ? "Emprunteur: " + costumeSelected.emprunteur : "Disponible à l'emprunt"
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
