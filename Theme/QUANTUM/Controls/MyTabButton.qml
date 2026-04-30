import QtQuick
import QtQuick.Controls
import ".."

TabButton {
    id: control

    implicitHeight: 40
    implicitWidth: 120

    contentItem: Text {
        text: control.text
        font: Fonts.body1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.checked ? Colors.bluegrey25 : Colors.lightblue900
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 6

        color: {
            if (control.checked && control.hovered)
                return Colors.primary900
            if (control.checked)
                return Colors.primary600        // actif
            if (control.hovered)
                return  Colors.primary200
            return Colors.primary100           // neutre
        }

        border.color: control.checked ? "#0078d4" : "#555555"
    }
}
