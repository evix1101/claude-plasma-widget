import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: usageBar

    property real value: 0.0        // 0.0 to 1.0
    property string label: ""       // e.g. "5h", "7d"
    property bool showPercentage: false

    implicitHeight: Kirigami.Units.gridUnit * 0.9
    implicitWidth: Kirigami.Units.gridUnit * 6

    readonly property color barColor: {
        if (value >= 0.90) return Kirigami.Theme.negativeTextColor;
        if (value >= 0.75) return Kirigami.Theme.neutralTextColor;
        return Kirigami.Theme.positiveTextColor;
    }

    RowLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        // Label
        Text {
            text: usageBar.label
            color: Kirigami.Theme.textColor
            font.pixelSize: parent.height * 0.7
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
            visible: usageBar.label !== ""
        }

        // Bar background
        Rectangle {
            id: barBackground
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 3
            color: Kirigami.Theme.backgroundColor
            border.color: Qt.rgba(Kirigami.Theme.textColor.r,
                                   Kirigami.Theme.textColor.g,
                                   Kirigami.Theme.textColor.b, 0.2)
            border.width: 1

            // Fill
            Rectangle {
                id: barFill
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.min(1.0, Math.max(0.0, usageBar.value))
                radius: parent.radius
                color: usageBar.barColor

                Behavior on width {
                    NumberAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Kirigami.Units.longDuration
                    }
                }
            }

            // Percentage overlay
            Text {
                anchors.centerIn: parent
                text: Math.round(usageBar.value * 100) + "%"
                color: Kirigami.Theme.textColor
                font.pixelSize: parent.height * 0.65
                font.bold: true
                visible: usageBar.showPercentage
                style: Text.Outline
                styleColor: Kirigami.Theme.backgroundColor
            }
        }
    }
}
