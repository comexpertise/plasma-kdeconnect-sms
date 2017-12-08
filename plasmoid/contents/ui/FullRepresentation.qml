import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

Item {
    id: fullRoot
    
    Layout.preferredWidth: plasmoid.configuration.width
    Layout.preferredHeight: plasmoid.configuration.height
    
    Component.onCompleted: { 
        //first update
        root.update();     
    }
    
    ColumnLayout {
        anchors.fill: parent
        TextField {
            id: "phonenumber"
            Layout.fillWidth: true
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: qsTr("Enter phone number");
        }

        TextArea {
            id: "smsmessage"
            Layout.fillWidth: true
            text: qsTr("Your message...")
            horizontalAlignment: TextInput.AlignHLeft;
        }

        Button {
            id: "btnsend"
            Layout.alignment: Qt.AlignRight
            text: qsTr("Send SMS")
            onClicked: {
                root.sendSMS({ phone: phonenumber.text, message: smsmessage.text });
            }
        }
    }
}

