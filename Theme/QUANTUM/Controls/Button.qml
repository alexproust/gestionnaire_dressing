import QtQuick
import QtQuick.Controls.Basic as Ctrl
import ".."

Ctrl.Button {
    id: control
    enum ButtonTypes {
        Filled,
        Outline,
        Ghost
    }

    enum ButtonColors {
        Primary,
        Neutral,
        Success,
        Warning,
        Danger
    }
    property int type: Button.ButtonTypes.Filled
    property int color: Button.ButtonColors.Primary

    onEnabledChanged: {
        colorChanged();
    }

//    MouseArea
//    {
//        id: mouseArea
//        anchors.fill: parent
//        onPressed:  mouse.accepted = false
//        cursorShape: Qt.PointingHandCursor
//        onCursorShapeChanged: console.log(cursorShape)
//    }

    states: [
        State {
            name: "FILLED"
            PropertyChanges {target: backContent; color: internal.colorRect; border.width: 0;}
            PropertyChanges {target: textContent; color: internal.colorText; }
        },
        State {
            name: "OUTLINE"
            PropertyChanges {target: backContent; color: Colors.transparent; border.width: 2; border.color: internal.colorRect}
            PropertyChanges {target: textContent; color: internal.colorRect; }
        },
        State {
            name: "GHOST"
            PropertyChanges {target: backContent; color: Colors.transparent; border.width: 0;}
            PropertyChanges {target: textContent; color: internal.colorRect; }
        },
        State {
            name: "DISABLED"
            when: !control.enabled
            PropertyChanges {target: backContent; color: Colors.bluegrey100; border.width: 0;}
            PropertyChanges {target: textContent; color: Colors.bluegrey400; }
//            PropertyChanges {target: mouseArea; cursorShape: Qt.ForbiddenCursor;} // https://bugreports.qt.io/browse/QTBUG-38306
        },
        State {
            name: "-PRIMARY"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Primary
            PropertyChanges {target: internal; colorRect: control.down ? Colors.blue700 : control.hovered ? Colors.blue600 : Colors.blue500; colorText: Colors.bluegrey25}
        },
        State {
            name: "-NEUTRAL"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Neutral
            PropertyChanges {target: internal; colorRect: control.down ? Colors.bluegrey900 : control.hovered ? Colors.bluegrey800 : Colors.bluegrey700; colorText: Colors.bluegrey25}
        },
        State {
            name: "-SUCCESS"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Success
            PropertyChanges {target: internal; colorRect: control.down ? Colors.green700 : control.hovered ? Colors.green600 : Colors.green500; colorText: Colors.bluegrey25}
        },
        State {
            name: "-WARNING"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Warning
            PropertyChanges {target: internal; colorRect: control.down ? Colors.orange700 :control.hovered ? Colors.orange600 : Colors.orange500; colorText: Colors.bluegrey25}
        },
        State {
            name: "-DANGER"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Danger
            PropertyChanges {target: internal; colorRect: control.down ? Colors.red700 : control.hovered ? Colors.red600 : Colors.red500; colorText: Colors.bluegrey25}
        }
    ]

    QtObject {
        id: internal
        property color colorRect
        property color colorText

        function computeBaseState() {
            switch(control.type) {
            case Button.ButtonTypes.Outline:
                return "OUTLINE";
            case Button.ButtonTypes.Filled:
                return "FILLED";
            case Button.ButtonTypes.Ghost:
                return "GHOST";
            }
        }
    }

    contentItem: Text {
        id:textContent
        font: Fonts.body2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: control.text
    }

    background: Rectangle {
        id: backContent
        implicitWidth: 150
        implicitHeight: 40
    }
}
