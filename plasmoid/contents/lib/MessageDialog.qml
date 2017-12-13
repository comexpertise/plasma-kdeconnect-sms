import QtQuick 2.2
import QtQuick.Dialogs 1.2

Dialog {
    id: dialogMessage
    visible: false
    title: "KDE Connect :: SMS Sender"

    contentItem: Rectangle {
        implicitWidth: 400
        implicitHeight: 100
        Text {
            id: dialogMessageText
            anchors.centerIn: parent
        }
    }

    function show(msg){
        dialogMessage.visible = true;
        dialogMessageText.text = msg;
    }
}
