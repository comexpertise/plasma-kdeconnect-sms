function isConstrained() {
    return (plasmoid.formFactor == PlasmaCore.Types.Vertical || plasmoid.formFactor == PlasmaCore.Types.Horizontal);
}

function sendSMS(values, callback) {
    if(!deviceName || deviceName === ''){
        messageDialog.show(qsTr("Please setup up first (see plasmoid configuration)!"));
        return;
    }

    if (values.phone !== '' && values.message !== '' && deviceName !== '') {
            getKDEConnectFirstReachableDevice(deviceName, function(deviceNameFound){
                // check paired phone if connected
                if(deviceNameFound !== deviceName){
                    messageDialog.show(qsTr("Your phone \"%1\" is not the only one paired and reachable device (actually: %2). This plamoid can only work with one paired device in KDEConnect.").arg(deviceName).arg(deviceNameFound));
                    return;
                }

                // send SMS
                executeCommand.exec('kdeconnect-cli --send-sms ' + shellescape([values.message]) + ' --destination ' + shellescape([values.phone]) + ' --name ' + shellescape([deviceName]), function() {
                if(plasmoid.configuration.speakerBeepReps > 0){
                    executeCommand.exec('beep -l ' + parseInt(plasmoid.configuration.speakerBeep) + ' -f 1000 -r ' + parseInt(plasmoid.configuration.speakerBeepReps));
                }
                callback();
            });
        }, function(deviceName){
            messageDialog.show(qsTr("Your phone is not connected, please check paired devices in KDEConnect."));
        });
    }
    else{
        messageDialog.show(qsTr("Please fill all fields (phone number + your message)!"));
    }
}

function checkDeviceConnected(deviceName){
    // TODO
}

// @see https://github.com/xxorax/node-shell-escape
function shellescape(a) {
  var ret = [];

  a.forEach(function(s) {
    if (/[^A-Za-z0-9_\/:=-]/.test(s)) {
      s = "'"+s.replace(/'/g,"'\\''")+"'";
      s = s.replace(/^(?:'')+/g, '') // unduplicate single-quote at the beginning
        .replace(/\\'''/g, "\\'" ); // remove non-escaped single-quote if there are enclosed between 2 escaped
    }
    ret.push(s);
  });

  return ret.join(' ');
}

function getKDEConnectFirstReachableDevice(deviceName, callbackOK, callbackKO){
    // TODO BUG in kdeconnect-cli? kdeconnect-cli return "paired and reachable" for device even if offline or renammed!
    executeCommand.exec("/bin/bash -c 'kdeconnect-cli --list-available | grep -Po \"^([\\d]+) device found$\" | cut -d \" \" -f1'", function(countDevicesFound) {
        if(parseInt(countDevicesFound) === 1){
            //TODO Get device ID!
            executeCommand.exec("/bin/bash -c 'kdeconnect-cli --list-available | grep -Po \"^- ([\\S\\s]+):\\s+\"'", function(stdout){
                var deviceNameFound = stdout.replace(new RegExp("(^- )|:\\s+", "g"),'');
                callbackOK(deviceNameFound)
            });
        }
        else{
            callbackKO(deviceName);
        }
    });
}

function getKDEConnectReachableDevices(callback){
    // TODO
}
