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

    Component.onCompleted: internal.computeBaseState()

    property bool isPressed: false
    property int type: Button.ButtonTypes.Filled
    property int color: Button.ButtonColors.Primary

    onPressed: isPressed = !isPressed

    QtObject {
        id: internal
        property color colorRect
        property color colorText: Colors.lightblue900
        property color colorTextSelected: Colors.bluegrey25
        property color colorTextDisabled: Colors.bluegrey400

        function computeBaseState() {
            backContent.colorChanged();
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

    onEnabledChanged: {
        colorChanged();
    }

    states: [
        State {
            name: "FILLED"
            PropertyChanges {target: backContent; color: internal.colorRect; border.width: 0; radius: height / 2}
        },
        State {
            name: "OUTLINE"
            PropertyChanges {target: backContent; color: Colors.transparent; border.width: 2; border.color: internal.colorRect; radius: height / 2}
        },
        State {
            name: "GHOST"
            PropertyChanges {target: backContent; color: Colors.transparent; border.width: 0; radius: height / 2}
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
            PropertyChanges {target: internal; colorRect: control.down ? Colors.primary600 : control.hovered ? Colors.primary200 : Colors.primary100}
        },
        State {
            name: "-NEUTRAL"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Neutral
            PropertyChanges {target: internal; colorRect: control.down ? Colors.bluegrey900 : control.hovered ? Colors.bluegrey800 : Colors.bluegrey700}
        },
        State {
            name: "-SUCCESS"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Success
            PropertyChanges {target: internal; colorRect: control.down ? Colors.green700 : control.hovered ? Colors.green600 : Colors.green500}
        },
        State {
            name: "-WARNING"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Warning
            PropertyChanges {target: internal; colorRect: control.down ? Colors.orange700 :control.hovered ? Colors.orange600 : Colors.orange500}
        },
        State {
            name: "-DANGER"
            extend: internal.computeBaseState()
            when: color === Button.ButtonColors.Danger
            PropertyChanges {target: internal; colorRect: control.down ? Colors.red700 : control.hovered ? Colors.red600 : Colors.red500}
        }
    ]

    contentItem: Text {
        id:textContent
        font: Fonts.body1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: control.text
        color: {
            if(control.enabled) {
                if(control.down) {
                    return internal.colorTextSelected
                } else {
                    return internal.colorText;
                }
            } else {
                return internal.colorTextDisabled;
            }
        }
    }

    background: Rectangle {
        id: backContent
        implicitWidth: 125
        implicitHeight: 32
    }
}
