import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Theme.QUANTUM 1.0

Rectangle {
    property var costumeSelected: ({})
    width: parent.width - 100
    height: parent.height - 100
    anchors.centerIn: parent
    radius: 50
    visible: false
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

            source: "./Data/Appli/Costumes/" + costumeSelected.content.id + "/" + costumeSelected.content.photos[0].path
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
                text: costumeSelected.content.id
                font: Fonts.subtitle1
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.description
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.description
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.genre
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.mode
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.epoque
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.couleur
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.taille
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.etat
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: costumeSelected.content.placement
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }
        }
    }
}
