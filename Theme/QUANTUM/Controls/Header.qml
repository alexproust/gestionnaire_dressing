import QtQuick 2.15
import QtQuick.Layouts 1.15

import ".."

RowLayout {
    id: control
    width: 1024

    property string title

    default property alias contentItem: content

    spacing: 24

    Item {
        Layout.preferredWidth: 1
        Layout.fillHeight: true
    }

    /* LOGO */
    // Image {
    //     Layout.alignment: Qt.AlignVCenter
    //     Layout.preferredHeight: 15
    //     Layout.preferredWidth: 117
    //     source: "../Images/Thales.svg"
    // }

    Text {
        Layout.alignment: Qt.AlignVCenter
        text: control.title
        font: Fonts.body1
        color: Colors.bluegrey500
    }

    Rectangle { ///> Séparateur vertical
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 1
        Layout.preferredHeight: 2 * control.height / 3
        color: Colors.bluegrey200
    }

    Item {
        id: content
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}
