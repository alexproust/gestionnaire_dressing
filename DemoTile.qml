import QtQuick

import QtQuick.Layouts

// import QtGraphicalEffects 1.15
import Theme.QUANTUM 1.0

Rectangle {
    id: tile
    width: 320
    height: 360

    signal tileSelect()

    property var costume: ({})

    layer.enabled: true
    // layer.effect: DropShadow {
    //     color: Colors.bluegrey100
    //     radius: 6
    //     transparentBorder: true
    //     verticalOffset: 4
    // }

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

        Text {
            Layout.fillWidth: true
            text: costume.content.id
            font: Fonts.subtitle1
        }

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            text: costume.content.description
            font: Fonts.body1
            wrapMode: Text.WordWrap
        }

        Image {
            Layout.preferredHeight: tile.height / 2
            Layout.preferredWidth: tile.width
            Layout.leftMargin: -col.anchors.leftMargin

            source: "./Data/Appli/Costumes/" + costume.content.id + "/" + costume.content.photos[0].path
        }
    }
}
