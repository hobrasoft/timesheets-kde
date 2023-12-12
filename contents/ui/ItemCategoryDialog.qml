/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import "api.js" as Api

Item {
    id: root;
    visible: false;
    anchors.fill: parent;
    BackgroundOver {}

    property string category: "";
    property string description: "";

    signal noCategoriesAvailable();
    signal categorySet(string category);

    onVisibleChanged: {
        if (!visible) { return; }
        var api = new Api.Api();
        api.onFinished = function(json) {
            catlistview.model = json;
            };
        api.categoriestree(category);
        }


    TimesheetsHeader {
        id: header;
        saveVisible: false;
        text: qsTr("Select category");
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
        clip: true;

        ListView {
            id: catlistview;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.topMargin: appStyle.textSize * 0.5;
            spacing: 5;
            delegate: Rectangle {
                width: parent.width;
                height: appStyle.textSize * 2;
                color: "#10ffffff";
                radius: 5;
                clip: true;
                Text {
                    anchors.fill: parent;
                    anchors.leftMargin: appStyle.textSize * 0.25;
                    anchors.rightMargin: appStyle.textSize * 0.25;
                    verticalAlignment: Text.AlignVCenter;
                    text: modelData.description;
                    font.pixelSize: appStyle.textSize;
                    color: initpage.currentCategory == modelData.category ? appStyle.textColorDiabled : appStyle.textColor;
                    }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (initpage.currentCategory == modelData.category) { return; }
                        var description = modelData.description;
                        var category = modelData.category;
                        // var xdata = DB.categoriesByParent(category);
                        var api = new Api.Api();
                        api.onFinished = function(json) {
                            if (json.length == 0) { root.noCategoriesAvailable(); }
                            if (json.length != 0) { catlistview.model = json; }
                            };
                        api.categoriestree(category);
                        // na konci! Pořadí důležité
                        root.description = description;
                        root.category = category;
                        root.categorySet(category);
                        }
                    }
                }
            }
        }

}
