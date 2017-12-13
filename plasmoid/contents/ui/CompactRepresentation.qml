import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: compactRoot
    Plasmoid.toolTipMainText: i18n("Send SMS with KDEConnect")
    Plasmoid.icon: "kdeconnect"

    PlasmaCore.IconItem {
        source: plasmoid.icon
        anchors.fill: parent
        active: mouseArea.containsMouse

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            icon: parent.source
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
            hoverEnabled: true
        }
    }
}
