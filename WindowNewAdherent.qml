import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts

import Theme.QUANTUM 1.0
import Gestionnaire_dressing 1.0

Rectangle {
    id: windowNewAdherent
    property var newAdherent: ({})
    width: parent.width - 400
    height: parent.height - 400
    anchors.centerIn: parent
    radius: 50
    visible: false
    color: Colors.bluegrey100
    signal addAdherent()

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
        z: windowNewAdherent.z-1
    }

    Button {
        id: closeButton
        text: "Annuler"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            parent.visible = false
        }
    }

    Button {
        id: saveButton
        text: "Ajouter"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        onClicked: {
            addAdherent()
        }
    }

    ColumnLayout {
        id: row
        anchors.top: closeButton.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 60
        spacing: 12

        RowLayout {
            Text {
                // Layout.fillWidth: true
                // Layout.preferredHeight: 64
                text: "Name: "
                font: Fonts.body1
                wrapMode: Text.WordWrap
            }
            TextArea {
                id: nameInput
                // text: windowDetailsCostume.description
                // Layout.fillWidth: true
                // Layout.preferredHeight: 64
                onTextChanged: {
                    newAdherent.name = text
                }
            }
        }
    }
}
