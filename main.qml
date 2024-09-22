import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15

import Theme.QUANTUM 1.0

AppliQuantum {
    id: root
    title: "Gestionnaire dressing"
    property var model: ({})
    property var filterTemplate: ({})


    property JSONLoader main: JSONLoader {
        source: "Data/Appli/main.json"

        function loadJsonTile(path) {
            let xhr = new XMLHttpRequest();
            xhr.open("GET", path);
            xhr.onreadystatechange = function() {
                if (xhr.readyState !== XMLHttpRequest.DONE) {
                    return;
                }
                var dataContent = JSON.parse(xhr.responseText);
                for (var i = 0; i < dataContent.length; i++ ) {
                    var key = "costume_" + i;
                    model[key] = {};
                    model[key].content =dataContent[i]
                }
                modelChanged();
            }
            xhr.send();
        }

        onJsonObjectChanged: {
            var dressing = jsonObject.main;
            root.headtitle = dressing.title;
            var dataPath = "Data/Appli/" + dressing.data;
            loadJsonTile(dataPath)
        }
    }

    property JSONWriter save: JSONWriter{
        source: "file://C:/Users/Alex/Documents/Gestionnaire_dressing/Data/Appli/test.json"
        dataModel: model

        function recordJsonFile() {
            write(model)
        }

        onDataModelChanged: {
            recordJsonFile()
        }
    }

    property JSONLoader filter: JSONLoader {
        source: "Data/Appli/Costumes/filter.json"

        onJsonObjectChanged: {
            var filters = jsonObject.filter
            filterTemplate.type = filters.type
            filterTemplate.genre = filters.genre
            filterTemplate.couleur = filters.couleur
            filterTemplate.taille = filters.taille
            filterTemplate.etat = filters.etat
            filterTemplateChanged()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 85
        anchors.margins: 24
        spacing: 12

        Filters { ///< Filters
            id: filters
            height: parent.height
            Layout.minimumWidth: 300
            Layout.preferredWidth: 550
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 8

            rawModel: root.model
            filter: root.filterTemplate
        }

        ScrollView {
            Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            Flow {
                id: itemFlow
                anchors.fill: parent
                spacing: 24
                clip: true

                Repeater {
                    model: Object.keys(filters.filteredModel).length;

                    delegate: DemoTile {
                        costume: Object.values(filters.filteredModel)[index]
                        onTileSelect: {
                            demoDetail.costumeSelected = costume
                            demoDetail.visible = true
                        }
                    }
                }
            }
        }
    }


    DemoDetail{
        id: demoDetail
        filter: root.filterTemplate
    }
}
