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
    property real price: 1000;
    property string currency: "Kč";
    property alias timesheets: listview.model;

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
        Repeater {
            id: listview;
            Rectangle {
                color: "transparent";
                width: xxxx.width;
                height: childrenRect.height;
                Text {
                    id: lvt1;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: modelData.date_from.formatYYYYMMDDHHMM();
                    width: parent.width * (showprice ? 0.28 : 0.33);
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt2;
                    anchors.left: lvt1.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: modelData.date_to.formatYYYYMMDDHHMM();
                    width: parent.width * (showprice ? 0.28 : 0.33);
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt3;
                    anchors.left: lvt2.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: modelData.date_from.secsTo(modelData.date_to).formatHHMM();
                    width: parent.width * (showprice ? 0.22 : 0.33);
                    horizontalAlignment: Text.AlignRight;
                    rightPadding: appStyle.h4Size/2;
                    }
                Text {
                    id: lvt4;
                    anchors.left: lvt3.right;
                    font.pixelSize: appStyle.smallSize;
                    color: appStyle.textColor;
                    text: Math.round(xxxx.price * modelData.date_from.secsTo(modelData.date_to)/3600);
                    width: parent.width * (showprice ? 0.22 : 0);
                    horizontalAlignment: Text.AlignRight;
                    visible: xxxx.showprice;
                    rightPadding: appStyle.h4Size/2;
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
            text: Number(xxxx.timesheets.reduce(function(accumulator, currentValue) { 
                    return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                    }, 0)).formatHHMM();
            width: parent.width * (showprice ? 0.22 : 0.33);
            horizontalAlignment: Text.AlignRight;
            rightPadding: appStyle.h4Size/2;
            }
        Text {
            id: ttl3;
            anchors.left: ttl2.right;
            font.pixelSize: appStyle.smallSize;
            color: appStyle.textColor;
            text: Math.round(Number(xxxx.timesheets.reduce(function(accumulator, currentValue) { 
                    return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                    }, 0)) * xxxx.price / 3600);
            width: parent.width * (showprice ? 0.22 : 0.33);
            horizontalAlignment: Text.AlignRight;
            rightPadding: appStyle.h4Size/2;
            visible: xxxx.showprice;
            }

        }

}

