import QtQuick
import QtQuick.Layouts

import Theme.QUANTUM 1.0

AppliQuantum {
    id: root
    title: "Démonstrateurs AVS/FLX"
    property var model: ({})
    property var filterTemplate: ({})


    property JSONLoader main: JSONLoader {
        source: "Data/Appli/main.json"

        function loadJsonTile(key) {
            let xhr = new XMLHttpRequest();
            xhr.open("GET", model[key].path);
            xhr.onreadystatechange = function() {
                if (xhr.readyState !== XMLHttpRequest.DONE) {
                    return;
                }
                model[key].content = JSON.parse(xhr.responseText);
                modelChanged();
            }
            xhr.send();
        }

        onJsonObjectChanged: {
            var demonstrateurs = jsonObject.main[0];

            root.title = demonstrateurs.title;
            for(var i = 0; i < demonstrateurs.articles.length; i++ ) {
                var refBench = demonstrateurs.articles[i];
                var key = "bench_" + i;
                model[key] = {};
                model[key].path = "Data/Appli/" + refBench.path;
                loadJsonTile(key)
            }
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
    width: 1920
    height: 1080

    RowLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 12

/*         Text {
            text: "Nos Démonstrateurs"
            font: Fonts.title1
            color: Colors.blue600
        } */

        Filters { ///< Filters
            id: filters
            height: parent.height
            Layout.preferredWidth: 400
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            spacing: 8

            rawModel: root.model
            filter: root.filterTemplate
            // Rectangle {
            //     anchors.fill: parent
            //     opacity: 0.2
            //     color: "red"
            // }
        }

        Flow {
            id: itemFlow
            Layout.preferredWidth: 1500
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
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
    DemoDetail{
        id: demoDetail
    }
}
