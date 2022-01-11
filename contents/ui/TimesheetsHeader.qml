/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import QtGraphicalEffects 1.12


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
    property alias deleteEnabled: buttonDelete.enabled;
    property alias saveVisible: buttonSave.visible;
    property alias deleteVisible: buttonDelete.visible;
    property alias cancelVisible: buttonCancel.visible;
    property alias spacerVisible: spacer.visible;

    signal saveClicked();
    signal cancelClicked();
    signal deleteClicked();
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
            if (!enabled) { return; }
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
            if (!enabled) { return; }
            cancelClicked();
            }
        }

    Button {
        enabled: false;
        visible: false;
        id: buttonDelete;
        anchors.top: parent.top;
        anchors.right: buttonCancel.left;
        anchors.rightMargin: 2;
        height: appStyle.labelSize * 2.5;
        width: height;
        onClicked: {
            if (!enabled) { return; }
            deleteClicked();
            }
        style: AppButtonStyleHeader {
            background: Rectangle {
                color: ((control.pressed) ? "#60ffffff" : ((control.enabled) ? "#10ffffff" : "transparent" ) )
                border.color: (control.enabled) ? "#30ffffff" : "transparent";
                border.width: 1;
                radius: 0;
                Image {
                    id: icon;
                    source: "trash.svg"
                    fillMode: Image.PreserveAspectFit;
                    anchors.fill: parent;
                    anchors.margins: width/5;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: icon;
                        color: (control.enabled) ? "tomato" : "#30ffffff";
                        source: icon;
                        }

                    }
                }
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



