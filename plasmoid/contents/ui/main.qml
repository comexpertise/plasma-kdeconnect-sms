import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kquickcontrolsaddons 2.0

Item {
    id: root
    
    Plasmoid.preferredRepresentation: isConstrained() ? Plasmoid.compactRepresentation : Plasmoid.fullRepresentation
    //Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}
        
    function isConstrained() {
        return (plasmoid.formFactor == PlasmaCore.Types.Vertical || plasmoid.formFactor == PlasmaCore.Types.Horizontal);
    }

    property var deviceName: plasmoid.configuration.device_name
    
    onDeviceNameChanged: {
        update();
    }
    
    Component.onCompleted: {}
    
    Dialog {
            id: "dialogMessage"
            visible: false
            title: "KDE Connect :: SMS Sender"

            contentItem: Rectangle {
                implicitWidth: 400
                implicitHeight: 100
                Text {
                    id: "dialogMessageText"
                    text: qsTr(msg)
                    anchors.centerIn: parent
                }
            }
        }
    
    function showMessage(msg){
        dialogMessage.visible = true;
        dialogMessageText.text = qsTr(msg);
    }
    
    function update() {
        if (deviceName === '') {
            plasmoid.setConfigurationRequired(true, 'You need to provide a Device Name');
        } else {
            plasmoid.setConfigurationRequired(false);
        }
    }
    
    function sendSMS(values) {
        root.update();
        
        if(!deviceName || deviceName === ''){
            showMessage("You need to provide a Device Name (see plasmoid configuration)");
            return;
        }
        
        if (values.phone !== '' && values.message !== '' && deviceName !== '') {
            executable.exec('kdeconnect-cli --send-sms "'+values.message+'" --destination "'+values.phone+'" --name "'+deviceName+'"');
            executable.exec('beep 1');
        }
        else{
            showMessage("You need to provide a Phone number with your message");
        }
    }
    
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var stdout = data["stdout"]
            
            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }
            
            exited(sourceName, stdout)
            disconnectSource(sourceName) // cmd finished
        }
        
        function exec(cmd, onNewDataCallback) {
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)
                    
        }
        signal exited(string sourceName, string stdout)
    }
}
