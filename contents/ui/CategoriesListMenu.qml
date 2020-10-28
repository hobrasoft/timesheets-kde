/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5


Rectangle {
    id: root;
    visible: false;
    anchors.fill: parent;
    color: "#80000000";

    property int dh: 0;
    property int dx: 0;
    property int dy: 0;
    property string ticket: '';
    property alias enableRemove: buttonRemove.enabled;

    signal change(string ticket);
    signal remove(string ticket);

    onVisibleChanged: {
        if (!visible) { return; }
        menu.x = (dx + menu.width > root.width) ? root.width - menu.width - 10 : dx;
        menu.y = (dy + dh + menu.height > root.height) ? dy - menu.height : dy + dh;
        }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.visible = false;
            }
        }

    Rectangle {
        id: menu;
        width: parent.width * 0.7;
        height: childrenRect.height;
        color: "black";
        radius: 0;
        ColumnLayout {
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 0;
            // anchors.leftMargin: appStyle.textSize * 0.25; 
            // anchors.rightMargin: appStyle.textSize * 0.25;
            // Rectangle { height: appStyle.textSize * 0.45; width: 1; }
            Button {
                text: qsTr("Change the ticket");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    root.change(root.ticket);
                    }
                }
            Button {
                id: buttonRemove;
                text: qsTr("Remove the ticket");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    root.remove(root.ticket);
                    }
                }
            // Rectangle { height: appStyle.textSize * 0.45; width: 1; }
            }
        }

}

