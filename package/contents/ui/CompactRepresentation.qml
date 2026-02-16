import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Item {
    id: compact

    readonly property real fiveHourUsage: root.fiveHourUsage
    readonly property real sevenDayUsage: root.sevenDayUsage
    readonly property bool showWeekly: Plasmoid.configuration.showWeeklyUsage
    readonly property bool showPercent: Plasmoid.configuration.showPercentageText
    readonly property bool hasError: root.errorMessage !== ""
    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
    Layout.minimumWidth: Kirigami.Units.gridUnit * 3

    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing / 2
            spacing: Kirigami.Units.smallSpacing / 2

            UsageBar {
                Layout.fillWidth: true
                Layout.fillHeight: true
                value: compact.hasError ? 0 : compact.fiveHourUsage
                label: "5h"
                showPercentage: compact.showPercent
            }

            UsageBar {
                Layout.fillWidth: true
                Layout.fillHeight: true
                value: compact.hasError ? 0 : compact.sevenDayUsage
                label: "7d"
                showPercentage: compact.showPercent
                visible: compact.showWeekly
            }
        }
    }
}
