import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0
import QtQuick.Dialogs 1.2

ConfigPage {
    id: page
    
    property alias cfg_deviceName: defaultDeviceName.text
    property alias cfg_speakerBeep: speakerBeep.value
    property alias cfg_speakerBeepReps: speakerBeepReps.value

    Component.onCompleted: {
        getKDEConnectDevices();
    }
    
    ConfigSection {
        height: 110;
        label: i18n("Device Name (See KDE Connect Settings)")
        
        Label {
            id: labelDefaultDeviceFound
            text: "✔ " + i18n("You only have one paired and reachable device, this device has been automatically setting up for you! Review and save now.")
            color: "green"
            visible: false
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        
        TextField {
            id: defaultDeviceName
            Layout.fillWidth: true
        }
    }
    
    ConfigSection {
        label: i18n("Invoke a short \"beep\" from internal speaker after SMS send? Indicate the bip duration in milliseconds (1000 = 1 second).")
        
        SpinBox {
            id: speakerBeep
            Layout.fillWidth: false        
            minimumValue: 50
            maximumValue: 10000
            value: 100
        }
    }
    
    ConfigSection {
        label: i18n("Repeats the same speaker beep multiple times? <b>Set 0 to totally disable internal speaker beep</b>.")
        
        SpinBox {
            id: speakerBeepReps
            Layout.fillWidth: false        
            minimumValue: 0
            maximumValue: 100
            value: 1
        }
    }
    
    function getKDEConnectDevices(){
        if(!defaultDeviceName.text || defaultDeviceName.text === ''){
            executable.exec("/bin/bash -c 'kdeconnect-cli --list-available | grep -Po \"^([\\d]+) device found$\" | cut -d \" \" -f1'", function(countDevicesFound) {
                if(parseInt(countDevicesFound) === 1){
                    //TODO store all found devices and provide select list
                    //TODO Get device ID!
                    executable.exec("/bin/bash -c 'kdeconnect-cli --list-available | grep -Po \"^- ([\\S\\s]+):\\s+\"'", function(deviceNameFound){
                        cfg_deviceName = deviceNameFound.replace(new RegExp("(^- )|:\\s+", "g"),'');
                        labelDefaultDeviceFound.visible = true;
                    });
                }
            });
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
