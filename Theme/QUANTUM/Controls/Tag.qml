import QtQuick
// import QtQuick.Controls 2.15 as Ctrl
import QtQuick.Controls.Basic as Ctrl

import ".."

Ctrl.Button {
    id: control
    enum TagTypes {
        Default,
        Rounded,
        Sharp
    }

    enum TagColors {
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
    property int type: Tag.TagTypes.Default
    property int color: Tag.TagColors.Primary

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
            case Tag.TagTypes.Default:
            case Tag.TagTypes.Rounded:
                return "ROUNDED";
            case Tag.TagTypes.Sharp:
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
            when: control.color === Tag.TagColors.Primary
            PropertyChanges {target: internal; colorBack: Colors.primary100; colorBackHovered: Colors.primary200; colorBackSelected: Colors.primary600; colorBackDisabled: Colors.primary50; colorBackSelectedHovered: Colors.primary900}
        }
        ,
        State {
            name: "-LIGHTBLUE"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.LightBlue
            PropertyChanges {target: internal; colorBack: Colors.lightblue100; colorBackHovered: Colors.lightblue200; colorBackSelected: Colors.lightblue600; colorBackDisabled: Colors.lightblue50; colorBackSelectedHovered: Colors.lightblue900}
        }
        ,
        State {
            name: "-GREEN"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Green
            PropertyChanges {target: internal; colorBack: Colors.green100; colorBackHovered: Colors.green200; colorBackSelected: Colors.green600; colorBackDisabled: Colors.green50; colorBackSelectedHovered: Colors.green900}
        }
        ,
        State {
            name: "-ORANGE"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Orange
            PropertyChanges {target: internal; colorBack: Colors.orange100; colorBackHovered: Colors.orange200; colorBackSelected: Colors.orange600; colorBackDisabled: Colors.orange50; colorBackSelectedHovered: Colors.orange900}
        }
        ,
        State {
            name: "-RED"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Red
            PropertyChanges {target: internal; colorBack: Colors.red100; colorBackHovered: Colors.red200; colorBackSelected: Colors.red600; colorBackDisabled: Colors.red50; colorBackSelectedHovered: Colors.red900}
        }
        ,
        State {
            name: "-YELLOW"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Yellow
            PropertyChanges {target: internal; colorBack: Colors.yellow100; colorBackHovered: Colors.yellow200; colorBackSelected: Colors.yellow600; colorBackDisabled: Colors.yellow50; colorBackSelectedHovered: Colors.yellow900}
        }
        ,
        State {
            name: "-BLUEGREY"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Bluegrey
            PropertyChanges {target: internal; colorBack: Colors.bluegrey100; colorBackHovered: Colors.bluegrey200; colorBackSelected: Colors.bluegrey600; colorBackDisabled: Colors.bluegrey50; colorBackSelectedHovered: Colors.bluegrey900}
        }
        ,
        State {
            name: "-PURPLE"
            extend: internal.computeBaseState()
            when: control.color === Tag.TagColors.Purple
            PropertyChanges {target: internal; colorBack: Colors.purple100; colorBackHovered: Colors.purple200; colorBackSelected: Colors.purple600; colorBackDisabled: Colors.purple50; colorBackSelectedHovered: Colors.purple900}
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
                if(control.isSelected) {
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
