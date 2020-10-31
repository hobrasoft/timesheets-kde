/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 2.7
import QtGraphicalEffects 1.12
import "api.js" as Api

Item {
    id: root;
    anchors.fill: parent;

    property var timesheets: [];
    property bool allActiveTickets: false;

    function isTimesheetRunning(x) {
        if (typeof x.timesheets === 'undefined') { return false; }
        for (var i=0; i<timesheets.length; i++) {
            if (timesheets[i].ticket == x.ticket) {
                return timesheets[i].running;
                }
            }
        return (x.timesheets.reduce(function(acc, cur) { return acc = acc || cur.date_to == null || cur.date_to === ''; }, false));
        }

    function toggleTimesheet(ticketData) {
        if (isTimesheetRunning(ticketData)) {
            stopTimesheet(ticketData.ticket);
          } else {
            startTimesheet(ticketData.ticket);
            }
        }

    function stopTimesheet(ticket) {
        var found = false;
        var timesheet = new Object();
        timesheet.ticket = ticket;
        timesheet.running = false;
        for (var i=0; i<timesheets.length; i++) {
            if (timesheets[i].ticket = ticket) {
                timesheets[i] = timesheet;
                found = true;   
                break;
                }
            }
        if (!found) { timesheets.push(timesheet); }
        var api1 = new Api.Api();
        api1.stopTimesheet(ticket);
        }

    function startTimesheet(ticket) {
        var found = false;
        var timesheet = new Object();
        timesheet.ticket = ticket;
        timesheet.running = true;
        for (var i=0; i<timesheets.length; i++) {
            if (timesheets[i].ticket = ticket) {
                timesheets[i] = timesheet;
                found = true;
                break;
                }
            }
        if (!found) { timesheets.push(timesheet); }
        var api1 = new Api.Api();
        api1.startTimesheet(ticket);
        }

    Item {
        id: header;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: childrenRect.height;

        Text {
            id: title;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: menu.left;
            font.pixelSize: appStyle.labelSize;
            text: "Title";
            color: appStyle.textColor;
            }

        Rectangle {
            id: menu;
            anchors.top: parent.top;
            anchors.right: parent.right;
            width: height;
            height: parent.height;
            radius: 5;
            color: "#10ffffff";
            
            Text {
                anchors.fill: parent;
                text: "...";
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                color: appStyle.textColor;
                }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    appmenu.visible = true;
                    }
                }
            }

        }

    ListView {
        id: listview;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.topMargin: header.height/5;
        spacing: 5;
        clip: true;
        
        delegate: Rectangle {
            width: listview.width;
            height: childrenRect.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;

            Item {
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: appStyle.h4Size/7;
                anchors.rightMargin: appStyle.h4Size/7;
                height: tname.height + appStyle.h4Size;

                Image {
                    id: icon;
                    source: typeof (modelData.ticket) === 'undefined' ? "folder.svg" : "check.svg";
                    height: tname.height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    fillMode: Image.PreserveAspectFit;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: icon;
                        color: (typeof (modelData.ticket) === 'undefined') 
                            ? "#80ffffff" 
                            :  modelData.statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;}).filter(function(x){return !x.status_ignored;}).pop().status_color;
                        source: icon;
                        }
                    }

                Text {
                    id: tname;
                    anchors.top: parent.top;
                    anchors.left: icon.right;
                    anchors.right: iconfunning.left;
                    anchors.leftMargin: icon.height/5;
                    anchors.topMargin: typeof (modelData.ticket) !== 'undefined' ? 0 : (parent.height-height)/2;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: modelData.description;
                    }

                Item {
                    id: line2;
                    anchors.top: tname.bottom;
                    anchors.left: tname.left;
                    anchors.bottom: parent.bottom;
                    visible: typeof (modelData.ticket) !== 'undefined';

                    Text {
                        id: lbl1;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: parent.top;
                        anchors.left: parent.left;
                        color: appStyle.textColor;
                        text: qsTr("Time:");
                        }

                    Text {
                        id: lbl2;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: lbl1.top;
                        anchors.left: lbl1.right;
                        anchors.leftMargin: appStyle.smallSize/2;
                        color: appStyle.textColor;
                        text: Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                    return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                    }, 0)).formatHHMMSS();

                        Component.onCompleted: {
                            if (typeof modelData.ticket === 'undefined') { return; }
                            timer.triggered.connect(function() {
                                var seconds = Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                            var t = (currentValue.date_to === '') 
                                                    ? currentValue.date_from.secsTo(new Date())
                                                    : currentValue.date_from.secsTo(currentValue.date_to);
                                            return accumulator + t
                                            }, 0))
                                lbl2.text = seconds.formatHHMMSS();
                                lbl4.text = Math.round(seconds * modelData.price / 3600)
                                });
                            }
                        }

                    Text {
                        id: lbl3;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: lbl2.top
                        anchors.left: lbl2.right;
                        anchors.leftMargin: appStyle.smallSize;
                        color: appStyle.textColor;
                        text: qsTr("Price:");
                        }

                    Text {
                        id: lbl4;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: parent.top;
                        anchors.left: lbl3.right;
                        anchors.leftMargin: appStyle.smallSize/2;
                        color: appStyle.textColor;
                        text: (typeof (modelData.ticket) === 'undefined') ? '' 
                                :  Math.round(Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                        return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                        }, 0)) * modelData.price / 3600);
                        }



                    }

                Image {
                    id: iconfunning;
                    source: isTimesheetRunning(modelData) ? "stopwatch.svg" : "stopwatch-light.svg";
                    height: tname.height;
                    fillMode: Image.PreserveAspectFit;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: iconedit.left;
                    anchors.rightMargin: width/3;
                    visible: typeof (modelData.ticket) === 'undefined' ? false
                            :  modelData.statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;}).filter(function(x){return !x.status_ignored;}).pop().status_can_be_run;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: iconfunning;
                        color: appStyle.textColor;
                        source: iconfunning;
                        }
                    }

                Image {
                    id: iconedit;
                    source: "edit.svg";
                    height: tname.height;
                    fillMode: Image.PreserveAspectFit;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    visible: (typeof (modelData.ticket) !== 'undefined');

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: iconedit;
                        color: appStyle.textColor;
                        source: iconedit;
                        }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            if (typeof modelData.ticket !== 'undefined') {
                                initpage.loadPage ("PageTicket.qml", { ticket: modelData.ticket } );
                                return;
                                }
                            loadData(modelData.category, modelData.parent_category);
                            }
                        }
                    }

                MouseArea {
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: iconfunning.right;
                    anchors.bottom: parent.bottom;
                    onClicked: {
                        if (typeof modelData.ticket !== 'undefined') {
                            var can_be_run = modelData.statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;}).filter(function(x){return !x.status_ignored;}).pop().status_can_be_run;
                            if (can_be_run === false) { return; }
                            console.log("can_be_run: " + can_be_run);
                            toggleTimesheet(modelData);
                            iconfunning.source = isTimesheetRunning(modelData) ? "stopwatch.svg" : "stopwatch-light.svg";
                            return;
                            }
                        loadData(modelData.category, modelData.parent_category);
                        }
                    }

                }

            }
        }

    Component.onCompleted: {
        loadData(initpage.currentCategory, initpage.parentCategory);
        }

    function loadData(category, pCategory) {
        initpage.parentCategory = pCategory;
        initpage.currentCategory = category;

        // Get the title
        allActiveTickets = (initpage.currentCategory == -1)
        if (allActiveTickets) {
            title.text = qsTr("All active tickets");
            }
        if (initpage.currentCategory == 0) {
            title.text = "/";
            }
        if (initpage.currentCategory > 0) {
            var api1 = new Api.Api();
            api1.onFinished = function(json) {
                title.text = json.description;
                }
            api1.category(initpage.currentCategory);
            }

        var data = new Array();
        if (initpage.currentCategory === 0 && initpage.parentCategory === 0) {
            data.push({category: -1, parent_category: 0, description: qsTr('All active tickets'), categories: [], price: 0 });
            }

        if (allActiveTickets) {
            data.push({category: initpage.parentCategory, parent_category: 0, description: '..', categories: [], price: 0 });
            listview.model = data;
            var api4 = new Api.Api();
            api4.onFinished = function(json) {
                listview.model = listview.model.concat(json);
                }
            api4.ticketsvwall();
            }

        if (!allActiveTickets) {
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                if (initpage.currentCategory != 0) {
                    data.push({category: initpage.parentCategory, parent_category: 0, description: '..', categories: [], price: 0 });
                    }
                listview.model = data.concat(json);
                var api3 = new Api.Api();
                api3.onFinished = function(json) {
                    listview.model = listview.model.concat(json);
                    }
                api3.ticketsvw(initpage.currentCategory);
                }
            api2.categoriestree(initpage.currentCategory);
            }
        }

    AppStyle { id: appStyle; }


    ApplicationMenu {
        id: appmenu;
        }

    function absolutePosition(node) {
        var returnPos = {};
        returnPos.x = 0;
        returnPos.y = 0;
        if (node !== undefined && node !== null) {
            var parentValue = absolutePosition(node.parent);
            returnPos.x = parentValue.x + node.x;
            returnPos.y = parentValue.y + node.y;
            }
        return returnPos;
        }

}


