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

    onVisibleChanged: {
        if (visible) { return; }
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

            Button {
                text: qsTr("Settings");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                visible: !initpage.kde;
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageSettings.qml");
                    }
                }

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
                enabled: settings.can_edit_categories;
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
                enabled: settings.can_edit_categories && Number(initpage.currentCategory) > 0;
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageCategory.qml", { currentCategory: initpage.currentCategory, parentCategory: initpage.parentCategory } );
                    }
                }

            Button {
                text: qsTr("Add new status to selected tickets");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                enabled: pageCategories.somethingChecked;
                onClicked: {
                    root.visible = false;
                    pageCategories.addStatusToSelectedTickets();
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

            Button {
                text: qsTr("About");
                Layout.fillWidth: true;
                Layout.preferredHeight: appStyle.labelSize * 2.5;
                style: AppButtonStyleContextMenu { }
                onClicked: {
                    root.visible = false;
                    initpage.loadPage("PageAbout.qml");
                    }
                }

            }

        }

}

