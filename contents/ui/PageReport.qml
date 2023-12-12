/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "api.js" as Api

Item {
    id: root;
    anchors.fill: parent;

    property int currentCategory: 0;
    property int parentCategory: 0;

    function createReport() {
        var st = [];
        for (var i = 0; i<statuses.count; i++) {
            if (statuses.get(i).checked) { st.push(statuses.get(i).status); }
            }
        var serverUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName;
        var api2 = new Api.Api();
        api2.onFinished = function(json) {
            var url = serverUrl+"/public/timesheet.shtml?id=" + json.id;
            Qt.openUrlExternally(url);
            initpage.loadPage("PageCategories.qml");
            }
        api2.overview(currentCategory, st);
        }

    Background {}

    TimesheetsHeader { 
        id: header; 
        saveText: qsTr("Open");
        text: qsTr("Create report");
        onSaveClicked: {
            createReport();
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        }


    ListView {
        id: listview;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.topMargin: header.height/5;
        anchors.bottomMargin: header.height/5;
        spacing: 5;
        clip: true;
        model: statuses;

        delegate:  Rectangle {
            width: listview.width;
            height: childrenRect.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            MInputCheckboxField {
                id: chbox;
                label: description;
                width: listview.width;
                partiallyCheckedEnabled: false;
                checkedState: statuses.get(index).checked ? Qt.Checked : Qt.UnChecked;
                onCheckedStateChanged: {
                    statuses.setProperty (index, "checked", checkedState == Qt.Checked);
                    }
                }

            }

        }
}

