import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
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
    
    Timer {
        id: timerLabelMessageSent
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            labelMessageSent.visible = false;
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        TextField {
            id: phonenumber
            Layout.fillWidth: true
            horizontalAlignment: TextInput.AlignHCenter
            inputMethodHints: Qt.ImhDialableCharactersOnly
            placeholderText: qsTr("Enter phone number");
            function _onEnterPressed(event)
            {
                smsmessage.focus = true;
            }

            Keys.onReturnPressed: { _onEnterPressed(event) }
            Keys.onEnterPressed: { _onEnterPressed(event) }
        }

        TextArea {
            id: smsmessage
            anchors.top: phonenumber.bottom
            anchors.topMargin: 10
            Layout.fillWidth: true
            textFormat: TextEdit.PlainText
            text: qsTr("💬 " + "Your message...")
            horizontalAlignment: TextInput.AlignHLeft;
        }
        
        Label{
            id: labelMessageSent
            text: "✔ " + qsTr("Message sent!")
            color: "yellowgreen"
            visible: false
            anchors.top: smsmessage.bottom
            anchors.topMargin: 10
        }
        
        Button {
            id: btnsend
            Layout.alignment: Qt.AlignRight
            text: qsTr("Send SMS") + " ⚡"
            onClicked: {
                root.sendSMS({ phone: phonenumber.text, message: smsmessage.text }, callbackSendSMS);
            }
        }
    }
    
    function callbackSendSMS(){
        smsmessage.text = "";
        smsmessage.focus = true;
        labelMessageSent.visible = true;
        timerLabelMessageSent.running = true
    }
}
