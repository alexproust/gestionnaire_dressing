import QtQuick 2.15
// import QtGraphicalEffects 1.15
import Theme.QUANTUM 1.0

Rectangle {
    id: appli
    width: 1920
    height: 1080

    property string title: ""
    default property alias contentItem: content.children

    Rectangle { ///> Header container
        id: headerContainer
        anchors.top: appli.top
        anchors.left: appli.left
        anchors.right: appli.right
        height: 64
        Header {
            id: header
            anchors.fill: parent
            title: appli.title
        }
        layer.enabled: true
        // layer.effect: DropShadow {
        //     color: Colors.bluegrey100
        //     radius: 6
        //     transparentBorder: true
        //     verticalOffset: 4
        // }
    }

    Rectangle {
        id: content

        color: Colors.bluegrey25
        anchors.top: headerContainer.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
