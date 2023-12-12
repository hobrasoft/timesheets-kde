/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import 'api.js' as Api;

Item {
    id: root;
    visible: false;
    anchors.fill: parent;
    BackgroundOver {}

    property var previousStatus: null;
    property string status: "";
    property string status_description: "";
    property string status_color: "";
    property string category: "";
    property string description: "";

    signal statusAdded();

    onVisibleChanged: {
        if (!visible) { return; }
        if (typeof previousStatus === 'object' && Array.isArray(previousStatus)) {
            t2.text = root.description;
            header.saveEnabled = false;
            var pStatus = previousStatus.map(function(x) { if (x == null) { x = ''; } return x; });
            var api = new Api.Api();
            api.onFinished = function(json) {
                // console.log( JSON.stringify(json) );
                statlistview.model = json;
                for (var i=0; i<statlistview.model.length; i++) {
                    statlistview.model[i].checked = false;
                    }
                };
            api.statuses(category, pStatus);
            }
        }

    function selectedStatus(index) {
        var model = statlistview.model;
        for (var i=0; i<model.length; i++) {
            model[i].checked = false;
            }
        model[index].checked = true;
        statlistview.model = model;
        header.saveEnabled = true;
        }

    
    TimesheetsHeader {
        id: header;
        saveEnabled: false;
        saveText: qsTr("Append new Status");
        onSaveClicked: {
            root.description = t2.text;
            root.visible = false;
            root.statusAdded();
            }
        onCancelClicked: {
            root.visible = false;
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

        Text {
            id: t1;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            text: qsTr("Description");
            font.pixelSize: appStyle.h6Size;
            color: appStyle.textColor;
            anchors.topMargin: appStyle.textSize * 0.5;
            }

        MInputTextArea {
            id: t2;
            anchors.top: t1.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.topMargin: appStyle.textSize * 0.5;
            height: root.height * 0.5;
            }

        Text {
            id: t3;
            anchors.top: t2.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            text: qsTr("Status");
            color: appStyle.textColor;
            font.pixelSize: appStyle.h6Size;
            anchors.topMargin: appStyle.textSize * 0.95;
            }

        ListView {
            id: statlistview;
            anchors.top: t3.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.topMargin: appStyle.textSize * 0.5;
            spacing: 4;
            delegate: Rectangle {
                width: parent.width;
                height: appStyle.textSize * 2;
                color: modelData.checked ? "#4080ff80" : "#10ffffff";
                radius: 5;
                clip: true;
                Text {
                    anchors.fill: parent;
                    anchors.leftMargin: appStyle.textSize * 0.25;
                    anchors.rightMargin: appStyle.textSize * 0.25;
                    verticalAlignment: Text.AlignVCenter;
                    text: modelData.description;
                    font.pixelSize: appStyle.textSize;
                    color: appStyle.textColor;
                    }
                Rectangle {
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    anchors.bottom: parent.bottom;
                    width: height;
                    radius: height/2;
                    color: modelData.color;
                    anchors.topMargin: parent.height*0.2;
                    anchors.rightMargin: parent.height*0.2;
                    anchors.bottomMargin: parent.height*0.2;
                    }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        root.status_description = modelData.description;
                        root.status_color = modelData.color;
                        root.status = modelData.status;
                        root.selectedStatus(index);
                        }
                    }
                }
            }
        }

}
