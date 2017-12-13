import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kquickcontrolsaddons 2.0
import "../code/lib/helpers.js" as MyComponents
import "../lib/"

// TODO
// Add a contact picker from Akonadi @see https://github.com/comexpertise/plasma-kdeconnect-sms/issues/3 @see https://github.com/dant3/qmlcompletionbox
// Add to panel as icon @see https://github.com/comexpertise/plasma-kdeconnect-sms/issues/2

Item {
    id: root
    width: 250
    height: 270

    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}

    Plasmoid.preferredRepresentation: MyComponents.isConstrained() ? Plasmoid.compactRepresentation : Plasmoid.fullRepresentation

    property var deviceName: plasmoid.configuration.defaultDeviceName

    onDeviceNameChanged: {
        update();
    }

    Component.onCompleted: {}

    ExecuteCommand{
        id: executeCommand
    }

    MessageDialog{
        id: messageDialog
    }

    function update() {
        if (deviceName === '') {
            plasmoid.setConfigurationRequired(true, 'You need to provide a Device Name!');
        } else {
            plasmoid.setConfigurationRequired(false);
        }
    }
}
