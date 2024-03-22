/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import 'api.js' as Api;

Item {
    id: root;
    anchors.fill: parent;
    Background{}


    property bool somethingChecked: false;
    property var checkedReports: [];

    function isChecked(data) {
        if (typeof data !== 'object') { return false; }
        if (typeof data.key === 'undefined') { return false; }
        return checkedReports.includes(data.key);
        } 

    function load() {
        busyIndicator.setBusy(true);
        listview.model = new Array();
        checkedReports = new Array();
        var api = new Api.Api();
        api.onFinished = function(json) {
            listview.model = json;
            console.log("json.length = " + json.length);
            busyIndicator.setBusy(false);
            }
        api.overview();
        }

    Component.onCompleted: {
        load();
        }

    TimesheetsHeader {
        id: header;
        saveVisible: false;
        text: qsTr("List of reports");
        deleteVisible: true;
        deleteEnabled: somethingChecked;
        onSaveClicked: {
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onDeleteClicked: {
            deleteReportDialog.visible = true;
            }
        }


    Item {
        id: content;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.topMargin: appStyle.textSize*0.1;
        anchors.leftMargin: appStyle.textSize*0.1;
        anchors.rightMargin: appStyle.textSize*0.1;
        anchors.bottomMargin: appStyle.textSize*0.1;

        ListView {
            id: listview;
            anchors.fill: parent;
            anchors.topMargin: appStyle.textSize * 0.5;
            spacing: 4;
            clip: true;
            delegate: Rectangle {
                width: listview.width;
                height: appStyle.textSize * 3.3;
                // color: modelData.checked ? "#4080ff80" : "#10ffffff";
                color: "#10ffffff";
                radius: 5;
                clip: true;
                Text {
                    id: t1;
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.leftMargin: appStyle.textSize * 0.25;
                    anchors.rightMargin: appStyle.textSize * 0.25;
                    verticalAlignment: Text.AlignVCenter;
                    text: modelData.category.description;
                    font.pixelSize: appStyle.textSize;
                    color: appStyle.textColor;
                    }
                Text {
                    id: t2;
                    anchors.top: t1.bottom;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.leftMargin: appStyle.textSize * 0.25;
                    anchors.rightMargin: appStyle.textSize * 0.25;
                    verticalAlignment: Text.AlignVCenter;
                    text: modelData.statuses.map(function(x) { return x.abbreviation; }).join(", ");
                    font.pixelSize: appStyle.textSize;
                    color: appStyle.textColor;
                    }

                MouseArea {
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: checker.left;
                    anchors.bottom: parent.bottom;
                    onClicked: {
                        var serverUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName;
                        var url = serverUrl+"/public/timesheet.shtml?id=" + modelData.key;
                        Qt.openUrlExternally(url);
                        //  initpage.loadPage("PageCategories.qml");
                        }
                    }

                MInputCheckbox {
                    id: checker;
                    // height: tname.height;
                    // width: height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    anchors.rightMargin: 0;
                    checked: isChecked(modelData);
                    onClicked: {
                        if (checker.checked && !isChecked(modelData)) {
                            checkedReports.push(modelData.key);
                            somethingChecked = checkedReports.length > 0;
                            return;
                            }
                        if (!checker.checked && isChecked(modelData)) {
                            const index = checkedReports.indexOf(modelData.key);
                            if (index < 0) { return; }
                            checkedReports.splice(index, 1);
                            somethingChecked = checkedReports.length > 0;
                            return;
                            }
                        }
                    }

                }
            }
        }

    AppBusyIndicator { id: busyIndicator; }

    QuestionDialog {
        id: deleteReportDialog;
        text: qsTr("Do you really want to delete selected reports?");
        onAccepted: {
            for (var i=0; i<checkedReports.length; i++) {
                var api = new Api.Api();
                api.onFinished = function(json) {
                    };
                api.onError = function(json) {
                    }
                api.removeOverview(checkedReports[i]);
                }
            timerReload.start();
            }
        Timer {
            id: timerReload;
            interval: 1000;
            onTriggered: {
                load();
                }
            }
        }

}
