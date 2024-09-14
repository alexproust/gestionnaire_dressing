import QtQuick
import QtQuick.Controls.Basic as Ctrl

import ".."

Ctrl.Switch {
    id: control
    enum SwitchTypes {
        Default,
        Rounded,
        Sharp
    }

    enum SwitchColors {
        Primary,
        LightBlue,
        Green,
        Orange,
        Red,
        Yellow,
        Bluegrey,
        Purple
    }

    Component.onCompleted: internal.computeBaseState()

    property bool isSelected: false
    property int type: Switch.SwitchTypes.Default
    property int color: Switch.SwitchColors.Primary

    onClicked: isSelected = !isSelected

    QtObject {
        id: internal
        property color colorBack
        property color colorBackHovered
        property color colorBackSelected
        property color colorBackSelectedHovered
        property color colorBackDisabled
        property color colorText: Colors.lightblue900
        property color colorTextSelected: Colors.bluegrey25
        property color colorTextDisabled: Colors.bluegrey400

        function computeBaseState() {
            backContent.colorChanged();
            switch(control.type) {
            case Switch.SwitchTypes.Default:
            case Switch.SwitchTypes.Rounded:
                return "ROUNDED";
            case Switch.SwitchTypes.Sharp:
                return "SHARP";
            }
        }
    }

    states: [
        State {
            name: "ROUNDED"
            PropertyChanges {target: backContent; radius: height / 2}
        },
        State {
            name: "SHARP"
            PropertyChanges {target: backContent; radius: 0}
        },
        State {
            name: "-PRIMARY"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Primary
            PropertyChanges {target: internal; colorBack: Colors.primary100; colorBackHovered: Colors.primary200; colorBackSelected: Colors.primary600; colorBackDisabled: Colors.primary50; colorBackSelectedHovered: Colors.primary900}
        }
        ,
        State {
            name: "-LIGHTBLUE"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.LightBlue
            PropertyChanges {target: internal; colorBack: Colors.lightblue100; colorBackHovered: Colors.lightblue200; colorBackSelected: Colors.lightblue600; colorBackDisabled: Colors.lightblue50; colorBackSelectedHovered: Colors.lightblue900}
        }
        ,
        State {
            name: "-GREEN"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Green
            PropertyChanges {target: internal; colorBack: Colors.green100; colorBackHovered: Colors.green200; colorBackSelected: Colors.green600; colorBackDisabled: Colors.green50; colorBackSelectedHovered: Colors.green900}
        }
        ,
        State {
            name: "-ORANGE"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Orange
            PropertyChanges {target: internal; colorBack: Colors.orange100; colorBackHovered: Colors.orange200; colorBackSelected: Colors.orange600; colorBackDisabled: Colors.orange50; colorBackSelectedHovered: Colors.orange900}
        }
        ,
        State {
            name: "-RED"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Red
            PropertyChanges {target: internal; colorBack: Colors.red100; colorBackHovered: Colors.red200; colorBackSelected: Colors.red600; colorBackDisabled: Colors.red50; colorBackSelectedHovered: Colors.red900}
        }
        ,
        State {
            name: "-YELLOW"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Yellow
            PropertyChanges {target: internal; colorBack: Colors.yellow100; colorBackHovered: Colors.yellow200; colorBackSelected: Colors.yellow600; colorBackDisabled: Colors.yellow50; colorBackSelectedHovered: Colors.yellow900}
        }
        ,
        State {
            name: "-BLUEGREY"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Bluegrey
            PropertyChanges {target: internal; colorBack: Colors.bluegrey100; colorBackHovered: Colors.bluegrey200; colorBackSelected: Colors.bluegrey600; colorBackDisabled: Colors.bluegrey50; colorBackSelectedHovered: Colors.bluegrey900}
        }
        ,
        State {
            name: "-PURPLE"
            extend: internal.computeBaseState()
            when: control.color === Switch.SwitchColors.Purple
            PropertyChanges {target: internal; colorBack: Colors.purple100; colorBackHovered: Colors.purple200; colorBackSelected: Colors.purple600; colorBackDisabled: Colors.purple50; colorBackSelectedHovered: Colors.purple900}
        }
    ]

    onToggled: {
        customFilter();
    }
    contentItem: Text {
        font: Fonts.body1
        text: control.text
        color: {
            if(control.enabled) {
                if(control.checked) {
                    return Colors.bluegrey25
                } else {
                    return  Colors.lightblue900;
                }
            } else {
                return Colors.bluegrey400;
            }
        }
    }
    background: Rectangle {
        id: backContent
        implicitWidth: 125
        implicitHeight: 32
        color: {
            if(!control.enabled) {
                return internal.colorBackDisabled;
            }

            if(control.isSelected) {
                if(control.hovered) {
                    return internal.colorBackSelectedHovered;
                }
                return internal.colorBackSelected;
            }

            if(control.hovered) {
                return internal.colorBackHovered;
            }

            return internal.colorBack;
        }
    }
}
