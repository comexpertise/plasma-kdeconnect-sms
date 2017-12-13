import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0
import "../../code/lib/helpers.js" as MyComponents
import "../../lib"

ConfigPage {
    id: page
    
    property alias cfg_defaultDeviceName: defaultDeviceName.text
    property alias cfg_defaultCountryCallingCode: defaultCountryCallingCode.text
    property alias cfg_speakerBeep: speakerBeep.value
    property alias cfg_speakerBeepReps: speakerBeepReps.value

    Component.onCompleted: {
        MyComponents.getKDEConnectFirstReachableDevice(defaultDeviceName,
            function(deviceNameFound){
                cfg_defaultDeviceName = deviceNameFound;
                labelDefaultDeviceFound.visible = true;
            }
        );
    }

    ExecuteCommand{
        id: executeCommand
    }
    
    ConfigSection {
        //TODO provide select list of ALL devices
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
        height: 110;
        label: i18n("Default country calling code")

        Label {
            text: i18n("Indicate a default country from https://en.wikipedia.org/wiki/List_of_country_calling_codes")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        TextField {
            id: defaultCountryCallingCode
            Layout.fillWidth: true
            placeholderText: qsTr("Example: \"+33\" for France")
            validator: RegExpValidator { regExp: /\+[0-9]{1,5}/ }
        }
    }

    ConfigSection {
        height: 110;
        label: i18n("Internal speaker")
        
        Label {
            text: i18n("Invoke a short \"beep\" from internal speaker after SMS send? Indicate the bip duration in milliseconds (1000 = 1 second). You need the \"beep\" package (sudo apt-get install beep)")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

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
}
