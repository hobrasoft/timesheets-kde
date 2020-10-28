/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5


Item {
    id: xxxx;
    width: parent.width;
    height: childrenRect.height;

    /*
     Podoba modelu:

        {
            "id":                   123,        // id, primární klíč v tabulce ticket_status
            "description":          "abcd",     // popis, zadává uživatel, v tabulce statuses
            "status":               2,          // status, odkaz do tabulky statuses
            "status_color":         "red",      // barva statutu, odkaz do tabulky statuses
            "status_description":   "Otevřeno"  // barva statutu, odkaz do tabulky statuses
        }

    */
    property int    status_id: 0;
//  property string status: "";
    property string description: "";
    property string category: "";
    property string status_description: "";
    property date   date: new Date();
    property var    root: null;
    property var    statuses: new Array();


    function deleteStatus(index) {
        console.log("mazu status " + status_id);
        buttonAdd.enabled = true;
        statuses.splice(index, statuses.length - index);
        listview.model = statuses;
        }


    Button {
        id: buttonAdd;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.topMargin: appStyle.textSize/5;
        text: qsTr("+");
        style: AppButtonStyle {}
        onClicked: {
            dialog.description = '';
            dialog.category = xxxx.category;
            dialog.previousStatus = (statuses.length > 0) ? statuses[statuses.length-1].status : null;
            dialog.visible = true;
            }
        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: buttonAdd.right;
        anchors.right: parent.right;
        anchors.bottom: buttonAdd.bottom;
        text: qsTr("Status");
        font.pixelSize: appStyle.labelSize;
        color: appStyle.textColor;
        rightPadding: appStyle.h4Size/2;
        leftPadding: appStyle.h4Size/2;
        verticalAlignment: Text.AlignVCenter;
        }

    ListView {
        id: listview;
        anchors.top: buttonAdd.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: spacing;
        height: contentHeight;
        clip: true;
        model: statuses;
        spacing: 2;
        delegate: Item {
            width: content.width;
            height: childrenRect.height;
            Button {
                id: buttondel;
                style: AppButtonStyle {}
                text: "×";
                anchors.left: parent.left;
                // enabled: created || modified;
                enabled: false;
                onClicked: {
                    xxxx.deleteStatus(index);
                    }
                }
            Text {
                id: lt1;
                anchors.top: parent.top;
                anchors.left: buttondel.right;
                height: buttondel.height;
                rightPadding: appStyle.h4Size/2;
                leftPadding: appStyle.h4Size/2;
                text: modelData.date.formatYYYYMMDDHHMM();
                font.pixelSize: appStyle.textSize;
                color: appStyle.textColor;
                verticalAlignment: Text.AlignVCenter;
                }

            Text {
                id: lt3;
                anchors.top: parent.top;
                anchors.left: lt1.right;
                anchors.right: parent.right;
                height: buttondel.height;
                rightPadding: appStyle.h4Size/2;
                leftPadding: appStyle.h4Size/2;
                text: modelData.status_description;
                font.pixelSize: appStyle.textSize;
                color: appStyle.textColor;
                verticalAlignment: Text.AlignVCenter;
                }

            Rectangle {
                anchors.top: parent.top;
                anchors.right: parent.right;
                anchors.bottom: lt3.bottom;
                width: height;
                radius: height/2;
                color: modelData.status_color;
                anchors.topMargin: parent.height*0.2;
                anchors.rightMargin: parent.height*0.2;
                anchors.bottomMargin: parent.height*0.2;
                }

            Text {  
                id: lt2;
                anchors.top: buttondel.bottom;
                anchors.left: lt1.left;
                anchors.right: parent.right;
                rightPadding: appStyle.h4Size/2;
                leftPadding: appStyle.h4Size/2;
                text: modelData.description;
                font.pixelSize: appStyle.smallerSize;
                color: appStyle.textColor;
                verticalAlignment: Text.AlignVCenter;
                wrapMode: Text.WordWrap;
                }
            }

        }

    ItemStatusDialog { 
        id: dialog; 
        parent: root;
        onStatusAdded: {
            status_id = 0;
            status = dialog.status;
            description = dialog.description;
            status_description = dialog.status_description;
            statuses.push({
                "id": 0,
                "user": initpage.userid,
                "description": dialog.description, 
                "status": dialog.status, 
                "status_description": dialog.status_description, 
                "status_color": dialog.status_color,
                "created": true,
                "modified": true,
                "date": new Date()
                });
            listview.model = statuses;
            }
        }

}

