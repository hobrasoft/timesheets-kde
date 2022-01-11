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

    property bool showprice: initpage.show_price;
    property var root: null;
    property real price: 0;
    property string currency: "Kč";
//  property alias timesheets: listview.model;


    function timesheets() {
        var x = new Array;
        for (var i=0; i<listModel.count; i++) {
            x.push(listModel.get(i));
            }
        return x;
        }


    function setTimesheets(x) {
        listModel.clear();
        for (var i=0; i<x.length; i++) {
            listModel.append(
                {"id":x[i].id,"ticket":x[i].ticket,"user":x[i].user,"date_from":x[i].date_from,"date_to":x[i].date_to}
                );
            }
        listview.model = listModel;
        recalculate();
        }


    function recalculate() {
        var sum = 0;
        for (var i=0; i<listModel.count; i++) {
            var x = listModel.get(i);
            var diff = x.date_from.secsTo(x.date_to);
            sum += diff;
            }
        ttl2.text = Number(sum).formatHHMM();
        ttl3.text = Math.round(sum * xxxx.price / 3600);
        }

    ListModel {
        id: listModel;
        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        text: qsTr("Spent time & price");
        font.pixelSize: appStyle.labelSize;
        color: appStyle.textColor;
        }

    Column {
        id: c1;
        anchors.top: t1.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: childrenRect.height;
        spacing: 2;
        ListView {
            id: listview;
            width: parent.width;
            height: contentHeight;
            delegate: Rectangle {
                color: "transparent";
                width: xxxx.width;
                height: childrenRect.height;
                Text {
                    id: lvt1;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: date_from.formatYYYYMMDDHHMM();
                    width: parent.width * (showprice ? 0.28 : 0.33);
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt2;
                    anchors.left: lvt1.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: date_to.formatYYYYMMDDHHMM();
                    width: parent.width * (showprice ? 0.28 : 0.33);
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt3;
                    anchors.left: lvt2.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: date_from.secsTo(date_to).formatHHMM();
                    width: parent.width * (showprice ? 0.22 : 0.33);
                    horizontalAlignment: Text.AlignRight;
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt4;
                    anchors.left: lvt3.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: Math.round(xxxx.price * date_from.secsTo(date_to)/3600);
                    width: parent.width * (showprice ? 0.22 : 0);
                    horizontalAlignment: Text.AlignRight;
                    visible: xxxx.showprice;
                    rightPadding: appStyle.h4Size/2;
                    }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        timesheetsEdit.showprice = initpage.show_price;
                        timesheetsEdit.price = xxxx.price;
                        timesheetsEdit.index = index;
                        timesheetsEdit.ticket = ticket;
                        timesheetsEdit.timesheetId = id;
                        timesheetsEdit.date_from = date_from;
                        timesheetsEdit.date_to = date_to;
                        timesheetsEdit.visible = true;
                        }
                    }
                }
            }
        }

    Rectangle {
        color: "transparent";
        width: xxxx.width;
        height: childrenRect.height;
        anchors.top: c1.bottom;
        Text {
            id: ttl1;
            font.pixelSize: appStyle.smallSize;
            color: appStyle.textColor;
            text: qsTr("Total");
            width: parent.width * (showprice ? 0.56 : 0.66);
            horizontalAlignment: Text.AlignLeft;
            rightPadding: appStyle.h4Size/2;
            }
        Text {
            id: ttl2;
            anchors.left: ttl1.right;
            font.pixelSize: appStyle.smallSize;
            color: appStyle.textColor;
            width: parent.width * (showprice ? 0.22 : 0.33);
            horizontalAlignment: Text.AlignRight;
            rightPadding: appStyle.h4Size/2;
            }
        Text {
            id: ttl3;
            anchors.left: ttl2.right;
            font.pixelSize: appStyle.smallSize;
            color: appStyle.textColor;
            width: parent.width * (showprice ? 0.22 : 0.33);
            horizontalAlignment: Text.AlignRight;
            rightPadding: appStyle.h4Size/2;
            visible: xxxx.showprice;
            }

        }

    ItemTimesheetsEdit {
        id: timesheetsEdit;
        parent: root;
        visible: false;
        onTimesheetDeleted: {
            listModel.remove(index);
            }
        onTimesheetUpdated: {
            listModel.setProperty(index, "date_from", date_from);
            listModel.setProperty(index, "date_to", date_to);
            recalculate();
            }
        }

}

