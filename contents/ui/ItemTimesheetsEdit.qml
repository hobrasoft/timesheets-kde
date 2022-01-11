/**
 * @file
import QtQuick.Layouts 1.5
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import 'api.js' as Api;

Rectangle {
    id: root;
    visible: false;
    anchors.fill: parent;
    color: "#303030"

    property real price: 0;
    property bool showprice: true;
    property string date_from: null;
    property string date_to: null;
    property int timesheetId: 0;
    property int ticket: 0;
    property int index: 0;

    signal timesheetDeleted();
    signal timesheetUpdated();

    onVisibleChanged: {
        if (!visible) { return; }
        header.saveEnabled = false;
        }

    onDate_fromChanged: {
        if (visible) { return; }
        t_date_from.text = date_from.formatYYYYMMDDHHMM();
        }

    onDate_toChanged: {
        if (visible) { return; }
        t_date_to.text = date_to.formatYYYYMMDDHHMM();
        }

    function recalculate() {
        var t = new Date(t_date_to.text.replace(" ", "T"));
        var f = new Date(t_date_from.text.replace(" ", "T"));
        var dateValid = t.getTime() === t.getTime() && f.getTime() === f.getTime();
        header.saveEnabled = dateValid;
        if (!dateValid) {
            return;
            }
        var diff = f.secsTo(t);
        interval.text = Number(diff).formatHHMM();
        t_price.text = Math.round(Number(diff) * root.price / 3600);
        }

    TimesheetsHeader {
        id: header;
        saveEnabled: true;
        saveVisible: true;
        deleteEnabled: true;
        deleteVisible: true;
        text: qsTr("Timesheet record");
        onCancelClicked: {
            root.visible = false;
            }
        onSaveClicked: {
            date_to = t_date_to.text;
            date_from = t_date_from.text;
            root.visible = false;
            root.timesheetUpdated();
            }
        onDeleteClicked: {
            root.visible = false;
            root.timesheetDeleted();
            }
        }


    ColumnLayout {
        id: content;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: appStyle.textSize*0.1;
        anchors.leftMargin: appStyle.textSize*0.1;
        anchors.rightMargin: appStyle.textSize*0.1;


        MInputTextField {
            id: t_date_from;
            Layout.fillWidth: parent;
            label: qsTr("Date & Time From");
            onTextChanged: { recalculate(); }
            }

        MInputTextField {
            id: t_date_to;
            Layout.fillWidth: parent;
            label: qsTr("Date & Time To");
            onTextChanged: { recalculate(); }
            }

        RowLayout {
            Text {
                text: qsTr("Interval");
                font.pixelSize: appStyle.labelSize;
                color: appStyle.textColor;
                }
            Text {
                id: interval;
                color: appStyle.textColor;
                font.pixelSize: appStyle.labelSize;
                text: " " ;
                }
            }

        RowLayout {
            Text {
                text: qsTr("Price");
                font.pixelSize: appStyle.labelSize;
                color: appStyle.textColor;
                visible: showprice;
                }
            Text {
                id: t_price;
                color: appStyle.textColor;
                font.pixelSize: appStyle.labelSize;
                text: " " ;
                visible: showprice;
                }
            }

        }

}
