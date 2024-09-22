import QtQuick 2.15
import QtQuick.Window 2.15
import Theme.QUANTUM 1.0

Window {
    minimumWidth: 1440
    minimumHeight: 900
    property alias headtitle: appli.headtitle
    property alias headerContainer: appli.headerContainer
    Rectangle {
        id: appli
        anchors.fill: parent

        property string headtitle: ""
        default property alias contentItem: content.children
        property alias headerContainer: headerContainer

        Rectangle { ///> Header container
            id: headerContainer
            anchors.top: appli.top
            anchors.left: appli.left
            anchors.right: appli.right
            height: 64
            Header {
                id: header
                anchors.fill: parent
                title: appli.headtitle
            }
            layer.enabled: true
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
}
