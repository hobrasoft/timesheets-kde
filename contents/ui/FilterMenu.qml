/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.5
import QtQml 2.7
import "api.js" as Api


Rectangle {
    id: root;
    visible: false;
    anchors.fill: parent;
    color: "#80000000";

    signal statusesChanged();

    property bool statusChanged: false

    onVisibleChanged: {
        if (visible) { 
            statusChanged = false;
            return; 
            }
        if (statusChanged) {
            statusesChanged();
            }
        }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.visible = false;
            }
        }

    Rectangle {
        id: menu;
        anchors.top: parent.top;
        anchors.right: parent.right;
        width: parent.width * 0.7;
        height: childrenRect.height;
        color: Qt.tint(appStyle.backgroundColor, "#20808080");
        radius: 0;
        ColumnLayout {
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 0;

            Repeater {
                id: listview;
                model: statuses;
                clip: true;

                MInputCheckboxField {
                    label: description;
                    width: listview.width;
                    partiallyCheckedEnabled: false;
                    checkedState: statuses.get(index).checked ? Qt.Checked : Qt.Unchecked;
                    onCheckedStateChanged: {
                        statuses.setProperty(index, "checked", checkedState == Qt.Checked);
                        statusChanged = true;
                        }
                    }
                }
            }
        }

}

