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

    onVisibleChanged: {
        if (visible) { return; }
        statusesChanged();
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
        color: "black";
        radius: 0;
        ColumnLayout {
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 0;

            Button {
                text: qsTr("Create new ticket");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageTicket.qml", { currentCategory: initpage.currentCategory, ticket: 0 } );
                    }
                }

            Button {
                text: qsTr("Create new category");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageCategory.qml", { parentCategory: initpage.currentCategory } );
                    }
                }

            Button {
                text: qsTr("Modify current category");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageCategory.qml", { currentCategory: initpage.currentCategory, parentCategory: initpage.parentCategory } );
                    }
                }

            Button {
                text: qsTr("Create report");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageReport.qml", { currentCategory: initpage.currentCategory, parentCategory: initpage.parentCategory } );
                    }
                }

            Repeater {
                id: listview;
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                model: statuses;
                clip: true;

                MInputCheckboxField {
                    label: description;
                    width: listview.width;
                    partiallyCheckedEnabled: false;
                    checkedState: statuses.get(index).checked ? Qt.Checked : Qt.UnChecked;
                    onCheckedStateChanged: {
                        statuses.setProperty(index, "checked", checkedState == Qt.Checked);
                        console.log("----------------- on checked state changed: " + checkedState + " " + (checkedState == Qt.Checked) + " " + statuses.get(index).checked );
                        }
                    }
                }
            }
        }

}

