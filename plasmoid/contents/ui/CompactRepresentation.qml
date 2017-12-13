import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: compactRoot

    PlasmaCore.IconItem {
        //system-run
        source: "kdeconnect"
        width: units.iconSizes.medium
        height: units.iconSizes.medium
        active: mouseArea.containsMouse

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            icon: parent.source
            mainText: "Send SMS with KDEConnect"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
            hoverEnabled: true
        }
    }
}
