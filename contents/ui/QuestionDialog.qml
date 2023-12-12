/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import "api.js" as Api

Rectangle {
    id: root;
    visible: false;
    anchors.fill: parent;
    color: "#30000000";

    property alias text: lbl.text;

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.visible = false;
            }
        }


    signal accepted();
    signal rejected();

    Rectangle {
        id: content;
        anchors.centerIn: parent;
        width: parent.width*0.8;
        height: parent.height/3
        color: Qt.tint(appStyle.backgroundColor, "#80000000");
        border.color: "#30ffffff"
        border.width: 1;
        clip: true;
        radius: 5;

        Text {
            id: lbl;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.margins: appStyle.textSize;
            font.pixelSize: appStyle.textSize;
            wrapMode: Text.WordWrap;
            color: appStyle.textColor;
            }

        Button {
            id: buttonNo;
            style: AppButtonStyle{}
            text: qsTr("No")
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.margins: appStyle.textSize;
            onClicked: {
                root.visible = false;
                root.rejected();
                }
            }

        Button {
            style: AppButtonStyle{}
            text: qsTr("Yes")
            anchors.right: buttonNo.left;
            anchors.bottom: parent.bottom;
            anchors.margins: appStyle.textSize;
            onClicked: {
                root.visible = false;
                root.accepted();
                }
            }

        }

}
