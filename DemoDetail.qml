import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Theme.QUANTUM 1.0

Rectangle {
    id: demoDetail
    property var costumeSelected: ({})
    property bool editMode: false
    property var filter: ({})
    width: parent.width - 100
    height: parent.height - 100
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey25
    signal recordModification()

    Tag {
        text: "Modification"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            demoDetail.editMode = !demoDetail.editMode
            if (isSelected){
                demoDetail.recordModification()
            }
        }
    }


    Tag {
        text: "Fermer"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            isSelected = false
            parent.visible = false
        }
    }

    MouseArea {
        width: parent.width + 100
        height: parent.height + 100
        anchors.centerIn: parent
        propagateComposedEvents: false
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            parent.visible = false
        }
        z: z-1
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Image {
            Layout.preferredHeight: row.height
            Layout.preferredWidth: row.width / 2
            Layout.leftMargin: -col.anchors.leftMargin
            fillMode: Image.PreserveAspectFit
            source: costumeSelected.content.photos ? "./Data/Appli/Costumes/" + costumeSelected.content.id + "/" + costumeSelected.content.photos[0].path : "./Data/Appli/Costumes/1234/robe-vintage-pour-ado-365.webp"
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
                text: "Id: " + costumeSelected.content.id
                font: Fonts.subtitle1
            }

            RowLayout {
                Text {
                    id: typeText
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    text: !demoDetail.editMode ? "Type: " + costumeSelected.content.type : "Type: "
                    font: Fonts.body1
                    wrapMode: Text.WordWrap
                }

                ComboBox {
                    id: typeSelected
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    visible: demoDetail.editMode
                    model: filter.type
                    onCurrentIndexChanged: {
                        costumeSelected.content.type = filter.type[currentIndex]
                        console.debug(filter.type[currentIndex])
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Description: " + costumeSelected.content.description
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Genre: " + costumeSelected.content.genre
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Mode: " + costumeSelected.content.mode
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Epoque: " + costumeSelected.content.epoque
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Couleur: " +costumeSelected.content.couleur
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Taille: " +costumeSelected.content.taille
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Etat: " + costumeSelected.content.etat
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: "Emplacement: " +costumeSelected.content.placement
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }
        }
    }
}
