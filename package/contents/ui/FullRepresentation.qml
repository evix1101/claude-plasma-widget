import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents3

PlasmaExtras.Representation {
    id: full

    readonly property real fiveHourUsage: root.fiveHourUsage
    readonly property real sevenDayUsage: root.sevenDayUsage
    readonly property string fiveHourResets: root.fiveHourResetsAt
    readonly property string sevenDayResets: root.sevenDayResetsAt
    readonly property string errorMsg: root.errorMessage

    implicitWidth: Kirigami.Units.gridUnit * 20
    implicitHeight: contentLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
    Layout.minimumWidth: Kirigami.Units.gridUnit * 18
    Layout.minimumHeight: Kirigami.Units.gridUnit * 12
    Layout.maximumWidth: Kirigami.Units.gridUnit * 30
    Layout.maximumHeight: Kirigami.Units.gridUnit * 30

    header: PlasmaExtras.PlasmoidHeading {
        RowLayout {
            anchors.fill: parent

            Kirigami.Heading {
                text: i18n("Claude Code Usage")
                level: 3
                Layout.fillWidth: true
            }

            PlasmaComponents3.ToolButton {
                icon.name: "view-refresh"
                onClicked: root.refresh()
                PlasmaComponents3.ToolTip {
                    text: i18n("Refresh now")
                }
            }
        }
    }

    // Error state
    PlasmaExtras.PlaceholderMessage {
        anchors.centerIn: parent
        width: parent.width - Kirigami.Units.gridUnit * 4
        visible: full.errorMsg !== ""
        iconName: "dialog-warning"
        text: i18n("Error")
        explanation: full.errorMsg
    }

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing
        visible: full.errorMsg === ""

        // 5-hour session section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true
                Kirigami.Heading {
                    text: i18n("Session (5 hour)")
                    level: 4
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: Math.round(full.fiveHourUsage * 100) + "%"
                    font.bold: true
                    color: {
                        if (full.fiveHourUsage >= 0.90) return Kirigami.Theme.negativeTextColor;
                        if (full.fiveHourUsage >= 0.75) return Kirigami.Theme.neutralTextColor;
                        return Kirigami.Theme.positiveTextColor;
                    }
                }
            }

            PlasmaComponents3.ProgressBar {
                Layout.fillWidth: true
                from: 0
                to: 1
                value: full.fiveHourUsage
            }

            QQC2.Label {
                text: full.fiveHourResets
                    ? i18n("Resets at %1", formatResetTime(full.fiveHourResets))
                    : i18n("Reset time unknown")
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                color: Kirigami.Theme.disabledTextColor
            }
        }

        // Separator
        Kirigami.Separator {
            Layout.fillWidth: true
            visible: Plasmoid.configuration.showWeeklyUsage
        }

        // 7-day weekly section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            visible: Plasmoid.configuration.showWeeklyUsage

            RowLayout {
                Layout.fillWidth: true
                Kirigami.Heading {
                    text: i18n("Weekly (7 day)")
                    level: 4
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: Math.round(full.sevenDayUsage * 100) + "%"
                    font.bold: true
                    color: {
                        if (full.sevenDayUsage >= 0.90) return Kirigami.Theme.negativeTextColor;
                        if (full.sevenDayUsage >= 0.75) return Kirigami.Theme.neutralTextColor;
                        return Kirigami.Theme.positiveTextColor;
                    }
                }
            }

            PlasmaComponents3.ProgressBar {
                Layout.fillWidth: true
                from: 0
                to: 1
                value: full.sevenDayUsage
            }

            QQC2.Label {
                text: full.sevenDayResets
                    ? i18n("Resets at %1", formatResetTime(full.sevenDayResets))
                    : i18n("Reset time unknown")
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                color: Kirigami.Theme.disabledTextColor
            }
        }
    }

    function formatResetTime(isoString) {
        if (!isoString) return "";
        var d = new Date(isoString);
        if (isNaN(d.getTime())) return isoString;
        return Qt.formatDateTime(d, "hh:mm AP on MMM d");
    }
}
