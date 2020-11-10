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

    TimesheetsHeader {
        id: header;
        text: qsTr("New report");
        saveText: qsTr("Open");
        deleteVisible: false;
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onSaveClicked: {
            console.log("savenina");
            var st = [];
            for (var i = 0; i<statuses.count; i++) {
                if (statuses.get(i).checked) { st.push(statuses.get(i).status); }
                }
            var serverUrl = initpage.serverUrl;
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                var url = serverUrl+"/public/timesheet.shtml?id=" + json.id;
                // console.log("nova sestava " + url);
                Qt.openUrlExternally(url);
                }
            api2.overview(currentCategory, st);
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
            height: t.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            CheckBox {
                id: chbox;
                anchors.top: t.top;
                anchors.left: parent.left;
                anchors.bottom: t.bottom;
                anchors.margins: 10;
                width: height;
                clip: true;
                partiallyCheckedEnabled: false;


                onCheckedStateChanged: {
                    statuses.setProperty (index, "checked", checkedState == Qt.Checked);
                    }

                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 40;
                        implicitHeight: 40;
                        radius: 10;
                        color: control.pressed ? "#20ffffff" : "#30ffffff";
                        border.color: "lightgray";
                        border.width: 2;
                        Rectangle {
                            visible: control.checkedState == Qt.Checked;
                            color: "#80ffffff";
                            radius: 8;
                            anchors.margins: 7;
                            anchors.fill: parent;
                            }
                        Rectangle {
                            visible: control.checkedState == Qt.PartiallyChecked;
                            border.color: "#80808080";
                            border.width: 3;
                            color: "transparent";
                            radius: 8;
                            anchors.margins: 8;
                            anchors.fill: parent;
                            }

                        }
                    }

                }

            Rectangle {
                id: circle;
                anchors.top: t.top;
                anchors.left: chbox.right;
                anchors.bottom: t.bottom;
                anchors.margins: 20;
                width: height;
                color: statusColor;
                radius: height/2;
                }

            Text {
                id: t;
                anchors.top: parent.top;
                anchors.left: circle.right;
                anchors.right: parent.right;
                anchors.leftMargin: 10;
                text: description;
                font.pixelSize: appStyle.labelSize;
                color: appStyle.textColor;
                height: appStyle.labelSize * 3;
                verticalAlignment: Text.AlignVCenter;
                }
            }

        }

    ListModel {
        id: statuses;
        }

    Component.onCompleted: {
        loadData();
        }

    function loadData() {
        console.log("PageReport::loadData()");
        var api = new Api.Api();
        api.onFinished = function(json) {
            for (var i=0; i<json.length; i++) {
                statuses.append({status: json[i].status, description: json[i].description, checked: false, statusColor: json[i].color});
                }
            };
        api.statusesAll();
        }

}

