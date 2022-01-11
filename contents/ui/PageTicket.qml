/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import 'api.js' as Api;

Item {
    id: root;
    visible: true;
    parent: initpage;
    anchors.fill: parent;
    anchors.margins: 0;
    focus: true;

    property int  currentCategory: 0;
    property bool created: false;
    property int  ticket: 0;

    Background{}

    function load() {
        if (root.ticket > 0) {
            var api = new Api.Api();
            api.onFinished = function(ticket) {
                header.text = ticket.ticket;
                itemDate.date = ticket.date;
                itemUser.user = ticket.user;
                itemDescription.description = ticket.description;
                itemPrice.price = ticket.price;
                itemTimesheets.price = ticket.price;
                itemTimesheets.setTimesheets(ticket.timesheets);
                // itemGps.positions = ticket.values.filter(function(item){return (item.name == "gps");});
                // itemPhoto.photos = ticket.files.filter(function(item){return (item.type.startsWith("image/"));});
                itemStatus.statuses = ticket.statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;});
                root.created = false;
                loadCategoriesTree(ticket.category);
                }
            api.ticketvw(root.ticket);
          } else {
            root.created = true;
            itemDate.date = new Date();
            itemUser.user = initpage.userid;
            if (root.currentCategory > 0) {
                loadCategoriesTree(root.currentCategory);
                }
            }
        }

    function loadCategoriesTree(c) {
        var api2 = new Api.Api();
        api2.onFinished = function(json) {
            json.map(function(x){itemCategory.appendCategory(x)});
            itemPrice.price = json.pop().price;
            itemTimesheets.price = itemPrice.price;
            itemTimesheets.recalculate();
            }
        api2.onError = function(text) { console.log(text); }
        api2.categoriesToRoot(c);
        }

    function save() {
        var ticket = new Object();
        ticket.ticket = root.ticket;
        ticket.category = itemCategory.category;
        ticket.date = itemDate.date;
        ticket.description = itemDescription.description;
        ticket.user = itemUser.user;
        ticket.modified = true;
        ticket.created = root.created
        ticket.price = itemPrice.price
        // ticket.values = itemGps.positions;
        // ticket.files = itemPhoto.photos;
        ticket.statuses = itemStatus.statuses;
        ticket.timesheets = itemTimesheets.timesheets();
        var api = new Api.Api();
        api.onFinished = function(json) {
            initpage.loadPage("PageCategories.qml");
            }
        api.saveTicket(ticket);
        }

    Keys.onReleased: {
        console.log("key released");
        if (event.key == Qt.Key_Back || event.key == Qt.Key_Escape) {
            event.accepted = true;
            initpage.loadPage("PageCategories.qml");
            }
        }

    Component.onCompleted: {
        load();
        }

    TimesheetsHeader {
        id: header;
        saveEnabled: itemCategory.category != "" || itemCategory.category > 0;
        deleteEnabled: root.ticket > 0;
        deleteVisible: true;
        text: qsTr("New ticket");
        onSaveClicked: {
            root.save();
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onDeleteClicked: {
            deleteDialog.visible = true;
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

        Item {
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;

            Flickable {
                anchors.fill: parent;
                clip: true;
                contentWidth: width;
                contentHeight: contentItem.childrenRect.height;

                ItemTimesheets {
                    id: itemTimesheets ;
                    anchors.top: parent.top;
                    root: root;
                    }

                Spacer { id: spacer1; anchors.top: itemTimesheets.bottom; }
                ItemPrice {
                    id: itemPrice;
                    anchors.top: spacer1.bottom;
                    height: 4.4*appStyle.labelSize;
                    }

                Spacer { id: spacer1a; anchors.top: itemPrice.bottom; }
                ItemDate {
                    id: itemDate;
                    anchors.top: spacer1a.bottom;
                    }

                Spacer { id: spacer1u; anchors.top: itemDate.bottom; }
                ItemUser {
                    id: itemUser;
                    anchors.top: spacer1u.bottom;
                    }
            

                Spacer { id: spacer2; anchors.top: itemUser.bottom; }
                ItemDescription {
                    id: itemDescription;
                    anchors.top: spacer2.bottom;
                    }

                Spacer { id: spacer3; anchors.top: itemDescription.bottom; }
                ItemCategory {
                    id: itemCategory;
                    anchors.top: spacer3.bottom;
                    canChangeCategory: true;
                    root: root;
                    }

                Spacer { id: spacer4; anchors.top: itemCategory.bottom; }
                ItemStatus {
                    id: itemStatus;
                    anchors.top: spacer4.bottom;
                    category: itemCategory.category;
                    root: root;
                    }
/*
                Spacer { id: spacer5; anchors.top: itemStatus.bottom; }
                ItemPhoto {
                    id: itemPhoto;
                    anchors.top: spacer5.bottom;
                    root: root;
                    }

                Spacer { id: spacer6; anchors.top: itemPhoto.bottom; }
                ItemGPS {
                    id: itemGps;
                    anchors.top: spacer6.bottom;
                    }
*/
                }
            }
        }

    QuestionDialog {
        text: qsTr("Do you really want to delete the ticket?");
        id: deleteDialog;
        onAccepted: {
            console.log("odchazim mazat ticket: " + root.ticket);
            var api = new Api.Api();
            api.onFinished = function() {
                initpage.loadPage("PageCategories.qml");
                };
            api.removeTicket(root.ticket);
            }
        }

}



