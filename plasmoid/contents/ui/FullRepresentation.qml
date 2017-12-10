import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.calendar 2.0 as PlasmaCalendar
import "../../../plasmoid/libs/libphonenumber-js/libphonenumber-js.min.js" as LibPhoneNumber

Item {
    id: fullRoot

    Layout.preferredWidth: plasmoid.configuration.width
    Layout.preferredHeight: plasmoid.configuration.height

    Component.onCompleted: {
        root.update();
    }

    property var phoneNumberTextFieldInitialFontSize: null

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
            verticalAlignment: TextInput.AlignTop
            inputMethodHints: Qt.ImhDialableCharactersOnly
            placeholderText: qsTr("+33 ...")
            validator: RegExpValidator { regExp: /\+[0-9]{0,14}/ }
            text: getPhonePrefix()

            onTextChanged: {
                if(this.text === ''){
                    this.text = getPhonePrefix()
                }
                else{
                    processPhoneNumberField(this)
                }
            }

            Component.onCompleted: {
                phoneNumberTextFieldInitialFontSize = this.font.pointSize
            }

            onFocusChanged: {
                if (this.focus || this.text !== "") {
                    this.font.pointSize = 20
                } else {
                    this.font.pointSize = phoneNumberTextFieldInitialFontSize
                }
            }

            function getPhonePrefix(){
                return (plasmoid.configuration.defaultCountryCallingCode ? plasmoid.configuration.defaultCountryCallingCode : null);
            }

            function processPhoneNumberField(fieldObj) {
                var phone_parse = new LibPhoneNumber.libphonenumber.parse(fieldObj.text)
                if (phone_parse.country !== undefined
                        && phone_parse.country !== "") {
                    countryName.text = "✔ " + qsTr(
                                "Country:") + " " + phone_parse.country
                    countryName.visible = true

                    var phone_formatted = new LibPhoneNumber.libphonenumber.asYouType().input(
                                fieldObj.text)
                    fieldObj.text = phone_formatted
                } else {
                    countryName.visible = false
                }
            }

            function _onEnterPressed(event) {
                processPhoneNumberField(this)

                smsmessage.focus = true
            }

            Keys.onReturnPressed: {
                _onEnterPressed(event)
            }
            Keys.onEnterPressed: {
                _onEnterPressed(event)
            }

            Text {
                anchors.fill: parent
                id: countryName
                visible: false
                color: "white"
                font.pointSize: 8
                opacity: 0.4
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                anchors.bottomMargin: 4
                anchors.leftMargin: 5
            }

            Glow {
                anchors.fill: countryName
                radius: 7
                opacity: 0.15
                samples: 20
                source: countryName
                visible: countryName.visible
            }
        }

        TextArea {
            id: smsmessage
            anchors.top: phonenumber.bottom
            anchors.topMargin: 10
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhNoPredictiveText
            textFormat: TextEdit.PlainText
            text: qsTr("💬 " + "Your message...")
            horizontalAlignment: TextInput.AlignHLeft;
        }

        Label {
            id: labelMessageSent
            text: "✔ " + qsTr("Message sent!")
            color: "yellowgreen"
            visible: false
            anchors.top: smsmessage.bottom
            anchors.topMargin: 8
        }

        Button {
            id: btnsend
            Layout.alignment: Qt.AlignRight
            text: qsTr("Send SMS") + " ⚡"
            onClicked: {
                root.sendSMS({
                                 phone: phonenumber.text,
                                 message: smsmessage.text
                             }, callbackSendSMS)
            }
        }
    }

    function callbackSendSMS() {
        smsmessage.text = ""
        smsmessage.focus = true
        labelMessageSent.visible = true
        timerLabelMessageSent.running = true;
    }
}
