/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import "api.js" as Api


Item {
    id: root;
    visible: true;
    anchors.fill: parent;
    focus: true;

    Keys.onReleased: {
        if (event.key == Qt.Key_Back || event.key == Qt.Key_Escape) {
            event.accepted = true;
            }
        }

    Background{}

    TimesheetsHeader { 
        id: header
        text: qsTr("Settings");
        onSaveClicked: {
            settings.serverName = serverName.text;
            settings.username   = username.text;
            settings.password   = password.text;
            settings.useSSL                    = useSSL.checkedState;
            settings.multiple_timesheets       = multiple_timesheets.checkedState;
            settings.show_price                = show_price.checkedState;
            settings.can_change_category       = can_change_category.checkedState;
            settings.can_edit_categories       = can_edit_categories.checkedState;
            var api7 = new Api.Api();
            api7.onFinished = function(json) {
                console.log(JSON.stringify(json));
                initpage.userid = json.userid;
                settings.show_show_price          = (json.admin || json.show_show_price);
                settings.show_can_change_category = (json.admin || json.show_can_change_category);
                settings.show_can_edit_categories = (json.admin || json.show_edit_categories);
                initpage.loadPage("PageCategories.qml");
                }
            api7.authenticate(initpage.username, initpage.password);
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        }

    ColumnLayout {
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: appStyle.textSize*0.8;
        anchors.leftMargin: appStyle.textSize*0.8;
        anchors.rightMargin: appStyle.textSize*0.8;
        spacing: appStyle.textSize * 0.5;


        MInputTextField {
            id: serverName;
            Layout.fillWidth: true;
            label: qsTr("Server Name");
            }

        MInputCheckboxField {
            id: useSSL;
            label: qsTr("Use SSL");
            Layout.fillWidth: true;
            partiallyCheckedEnabled: false;
            }

        MInputTextField {
            id: username;
            Layout.fillWidth: true;
            label: qsTr("User name");
            }

        MInputTextField {
            id: password;
            Layout.fillWidth: true;
            label: qsTr("User password");
            echoMode: TextInput.Password;
            }

        MInputCheckboxField {
            id: multiple_timesheets;
            label: qsTr("Multiple running tasks allowed");
            Layout.fillWidth: true;
            partiallyCheckedEnabled: false;
            }

        MInputCheckboxField {
            id: show_price;
            label: qsTr("Show price");
            Layout.fillWidth: true;
            partiallyCheckedEnabled: false;
            }

        MInputCheckboxField {
            id: can_change_category;
            label: qsTr("User can change ticket's category");
            Layout.fillWidth: true;
            partiallyCheckedEnabled: false;
            }

        MInputCheckboxField {
            id: can_edit_categories;
            label: qsTr("User can create/modify/remove categories");
            Layout.fillWidth: true;
            partiallyCheckedEnabled: false;
            }

        }

    Component.onCompleted: {
        username.text                       = settings.username;
        password.text                       = settings.password;
        serverName.text                     = settings.serverName;
        useSSL.checkedState                 = settings.useSSL ? Qt.Checked : Qt.Unchecked;
        multiple_timesheets.checkedState    = settings.multiple_timesheets ? Qt.Checked : Qt.Unchecked;
        show_price.checkedState             = settings.show_price ? Qt.Checked : Qt.Unchecked;
        can_change_category.checkedState    = settings.can_change_category ? Qt.Checked : Qt.Unchecked;
        can_edit_categories.checkedState    = settings.can_edit_categories ? Qt.Checked : Qt.Unchecked;
        multiple_timesheets.visible         = false; // settings.show_multiple_timesheets;
        show_price.visible                  = settings.show_show_price;
        can_change_category.visible         = settings.show_can_change_category;
        can_edit_categories.visible         = settings.show_can_edit_categories;
        }


    // TimesheetsMenu { item: "settings"; }

}



