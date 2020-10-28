/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5

Rectangle {
    id: root;
    visible: true;
    anchors.top: parent.top;
    anchors.left: parent.left;
    anchors.right: parent.right;

    height: childrenRect.height;

    // Recognized values: settings, list, sync, ticket
    property string saveText: qsTr("Save");
    property string cancelText: qsTr("×");
    property string text: "";
    property alias saveEnabled: buttonSave.enabled;
    property alias cancelEnabled: buttonCancel.enabled;
    property alias saveVisible: buttonSave.visible;
    property alias cancelVisible: buttonCancel.visible;
    property alias spacerVisible: spacer.visible;

    signal saveClicked();
    signal cancelClicked();
    color: "transparent";

    Button {
        id: buttonSave;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.topMargin: 0;
        anchors.leftMargin: 0;
        text: root.saveText;
        style: AppButtonStyleHeader {}
        height: appStyle.labelSize * 2.5;
        onClicked: {
            saveClicked();
            }
        }

    Button {
        id: buttonCancel;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.margins: 0;
        text: root.cancelText;
        style: AppButtonStyleHeader {}
        height: appStyle.labelSize * 2.5;
        onClicked: {
            cancelClicked();
            }
        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: buttonSave.right;
        anchors.right: parent.right;
        anchors.bottom: buttonSave.bottom;
        anchors.leftMargin: appStyle.textSize*0.8 - (buttonSave.visible ? 0 : buttonSave.width);
        text: root.text;
        font.pixelSize: appStyle.textSize;
        verticalAlignment: Text.AlignVCenter;
        height: appStyle.labelSize * 2.5;
        color: appStyle.textColor;
        }

    Spacer { 
        id: spacer;
        anchors.top: buttonSave.bottom; 
        height: 4; 
        visible: root.spacerVisible; 
        }



}



