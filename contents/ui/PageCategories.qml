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


    function isTicket(index) {
        if (typeof index !== 'number') { return false; }
        if (index == -1) { return false; }
        if (typeof timesheetsmodel.get(index) !== 'object') { return false; }
        if (typeof timesheetsmodel.get(index).ticket === 'number' && timesheetsmodel.get(index).ticket != 0) { return true; }
        if (typeof timesheetsmodel.get(index).ticket === 'undefined') { return false; }
        return false;
        }

    function isCategory(index) {
        return !isTicket(index);
        }

    function canBeRun(index) {
        if (!isTicket(index)) { return false; }
        var item = timesheetsmodel.get(index);
        if (typeof item.statuses === 'undefined') { return false; }
        var statuses = item.statuses;
        console.log("canBeRun(index): " + typeof(item) + " " + typeof(statuses) + " " + Array.isArray(statuses) + " " + typeof(statuses.length) + ' ' + statuses.length);
        if (statuses.length === 0) { return false; }
        console.log("canBeRun(index): " + JSON.stringify(statuses[0]));
        return statuses
              .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
              .filter(function(x){return !x.status_ignored;})
              .pop().status_can_be_run;
        }

    function isTimesheetRunning(x) {
        return false;
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
            id: refresh;
            anchors.top: menu.top;
            anchors.right: menu.left;
            width: height;
            height: menu.height;
            radius: 5;
            color: "#10ffffff";
            
            Image {
                id: refreshIcon;
                anchors.fill: parent;
                anchors.margins: 5;
                source: "sync-alt-solid.svg";
                fillMode: Image.PreserveAspectFit;

                layer.enabled: true;
                layer.effect: ColorOverlay {
                    anchors.fill: refreshIcon;
                    color: "#80ffffff" 
                    source: refreshIcon;
                    }
                }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    loadData(initpage.currentCategory);
                    }
                }
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
        anchors.bottom: footer.top;
        anchors.topMargin: header.height/5;
        anchors.bottomMargin: header.height/5;
        spacing: 5;
        clip: true;
        model: timesheetsmodel;

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
                    source: isTicket(index) ? "check.svg" : "folder.svg";
                    height: tname.height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    fillMode: Image.PreserveAspectFit;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: icon;
                    /*
                        color: (typeof (ticket) === 'undefined') 
                            ? "#80ffffff" 
                            :  timesheetsmodel.get(index).statuses
                                .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
                                .filter(function(x){return !x.status_ignored;})
                                .pop().status_color;
                    */
                        source: icon;
                        }
                    }

                Text {
                    id: tname;
                    anchors.top: parent.top;
                    anchors.left: icon.right;
                    anchors.right: iconfunning.left;
                    anchors.leftMargin: icon.height/5;
                    anchors.topMargin: isTicket(index) ? 0 : (parent.height-height)/2;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: description;
                    }

                Item {
                    id: line2;
                    anchors.top: tname.bottom;
                    anchors.left: tname.left;
                    anchors.bottom: parent.bottom;
                    visible: isTicket(index);

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
                        text: isTicket(index)
                              ? Number(timesheets.reduce(function(accumulator, currentValue) {
                                    return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                    }, 0)).formatHHMMSS()
                              : "";

                        Component.onCompleted: {
                            if (!isTicket(index)) { return; }
/*
                            // fix časovač
                            timer.triggered.connect(function() {
                                var item = timesheetsmodel.get(index);
                                if (typeof item.timesheets === 'undefined') { return; }
                                if (item.timesheets.length === 0) { return; }
                                var seconds = Number(timesheets.reduce(function(accumulator, currentValue) {
                                            if (typeof currentValue == 'undefined') { return accumulator; }
                                            if (typeof currentValue.date_to == 'undefined') { return accumulator; }
                                            if (typeof currentValue.date_from == 'undefined') { return accumulator; }
                                            var t = (currentValue.date_to === '') 
                                                    ? currentValue.date_from.secsTo(new Date())
                                                    : currentValue.date_from.secsTo(currentValue.date_to);
                                            return accumulator + t
                                            }, 0))
                                lbl2.text = seconds.formatHHMMSS();
                                lbl4.text = Math.round(seconds * price / 3600)
                                });
*/
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
                        text: isCategory(index) 
                                ? '' 
                                :  Math.round(Number(timesheets.reduce(function(accumulator, currentValue) {
                                        return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                        }, 0)) * price / 3600);
                        }

                    Text {
                        id: lbl5;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: lbl2.top
                        anchors.left: lbl4.right;
                        anchors.leftMargin: appStyle.smallSize;
                        color: appStyle.textColor;
                        text:  isTicket(index) && timesheetsmodel.get(index).statuses.length > 0
                                ? timesheetsmodel.get(index).statuses
                                    .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
                                    .filter(function(x){return !x.status_ignored;})
                                    .pop().status_description
                                : "";
                        }


                    }

                Image {
                    id: iconfunning;
                    source: isTimesheetRunning(timesheetsmodel.get(index)) ? "stopwatch.svg" : "stopwatch-light.svg";
                    height: tname.height;
                    fillMode: Image.PreserveAspectFit;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: iconedit.left;
                    anchors.rightMargin: width/3;
                    visible: canBeRun(index);
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
                    anchors.right: checker.left;
                    anchors.rightMargin: width/3;
                    visible: isTicket(index);

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: iconedit;
                        color: appStyle.textColor;
                        source: iconedit;
                        }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            if (isTicket(index)) {
                                initpage.loadPage ("PageTicket.qml", { ticket: timesheetsmodel.get(index).ticket } );
                                return;
                                }
                            loadData(category, parent_category);
                            }
                        }
                    }

                MInputCheckbox {
                    id: checker;
                    height: 50;
                    width: height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    anchors.rightMargin: 0;
                    visible: isTicket(index);
                    checked: checked;
                    onClicked: {
                        }
                    }

                MouseArea {
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: iconfunning.right;
                    anchors.bottom: parent.bottom;
                    onClicked: {
                        if (isTicket(index) && canBeRun(index)) {
                            toggleTimesheet(item);
                            iconfunning.source = isTimesheetRunning(item) ? "stopwatch.svg" : "stopwatch-light.svg";
                            return;
                            }
                        loadData(category, parent_category);
                        }
                    }

                }

            }
        }

    Rectangle {
        id: footer;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        height: appStyle.smallSize * 2;
        color: "#10ffffff";
        radius: 5;
        clip: true;

        Text {
            id: footerTimeLbl;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 30
            font.pixelSize: appStyle.smallSize;
            verticalAlignment: Text.AlignVCenter;
            color: appStyle.textColor;
            text: qsTr("Time:");
            }

        Text {
            id: footerTime;
            anchors.top: parent.top;
            anchors.left: footerTimeLbl.right;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 10
            font.pixelSize: appStyle.smallSize;
            verticalAlignment: Text.AlignVCenter;
            color: appStyle.textColor;
            }

        Text {
            id: footerPriceLbl;
            anchors.top: parent.top;
            anchors.left: footerTime.right;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 30;
            font.pixelSize: appStyle.smallSize;
            verticalAlignment: Text.AlignVCenter;
            color: appStyle.textColor;
            text: qsTr("Price:");
            }

        Text {
            id: footerPrice;
            anchors.top: parent.top;
            anchors.left: footerPriceLbl.right;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 10
            font.pixelSize: appStyle.smallSize;
            verticalAlignment: Text.AlignVCenter;
            color: appStyle.textColor;
            }

        }

    Component.onCompleted: {
        var api7 = new Api.Api();
        api7.onFinished = function(json) {
            initpage.userid = json.userid;
            loadData(initpage.currentCategory);
            }
        api7.authenticate(initpage.username, initpage.password);
        }

    function loadData(category) {
        console.log("loadData(category) : " + category + " " + initpage.parentCategory);
        if (category == -999) {
            category = initpage.parentCategory;
            }
        initpage.parentCategory = initpage.currentCategory;
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
                title.text = '(' + initpage.currentCategory + ') ' + json.description;
                initpage.parentCategory = json.parent_category;
                }
            api1.category(initpage.currentCategory);
            }

        timesheetsmodel.clear();
        var data = new Array();
        if (initpage.currentCategory === 0) {
            timesheetsmodel.append({category: -1, parent_category: 0, description: qsTr('All active tickets'), categories: [], price: 0 });
            }

        if (allActiveTickets) {
            console.log("Nacitam allActiveTickets");
            timesheetsmodel.append({category: 0, parent_category: 0, description: '..', categories: [], price: 0 });
            // listview.model = data;
            var api4 = new Api.Api();
            api4.onFinished = function(json) {
                // filter selected categories
                var stats = initpage.statusesArray();
                console.log("PageCategories " + JSON.stringify(json));
                json = json
                    .filter(function(x) {
                        if (typeof x.statuses === 'undefined') { return true; }
                        if (x.statuses.length === 0) { return true; }
                        var x_status = x.statuses
                                .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
                                .filter(function(s){return !s.status_ignored;}).pop().status;
                        return stats.includes(x_status)
                        })
                    .map(function(x) {
                        var n = x;
                        n.checked = true;
                        return n;
                        });

                timesheetsmodel.appendArray(json);
                sumToFooter(json);
                // listview.model = listview.model.concat(json);
                }
            api4.ticketsvwall();
            }

        if (!allActiveTickets) {
            console.log("Nacitam not allActiveTickets " + initpage.currentCategory);
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                if (initpage.currentCategory != 0) {
                    timesheetsmodel.append({category: -999, parent_category: 0, description: '..', categories: [], price: 0 });
                    }
                timesheetsmodel.appendArray(json);
                // listview.model = data.concat(json);
                var api3 = new Api.Api();
                api3.onFinished = function(json) {
                    // filter selected categories
                    var stats = initpage.statusesArray();
                    json = json
                        .filter(function(x) {
                            if (typeof x.statuses === 'undefined') { return true; }
                            if (x.statuses.length === 0) { return true; }
                            var x_status = x.statuses
                                    .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
                                    .filter(function(s){return !s.status_ignored;}).pop().status;
                            return stats.includes(x_status);
                            })
                        .map(function(x) {
                            var n = x;
                            n.checked = true;
                            return n;
                            });
                    timesheetsmodel.appendArray(json);
                    sumToFooter(json);
                    // listview.model = listview.model.concat(json);
                    }
                api3.ticketsvw(initpage.currentCategory);
                }
            api2.categoriestree(initpage.currentCategory);
            }
        }


    function sumToFooter(data) {
        var time = 
            Number(data.reduce(function(a1, v1) {
                return a1 + v1.timesheets.reduce(function(a2, v2) { return a2 + v2.date_from.secsTo(v2.date_to) }, 0);
                }, 0)).formatHHMMSS();
        var price = 
            Number(data.reduce(function(a1, v1) {
                return a1 + v1.price * v1.timesheets.reduce(function(a2, v2) { return a2 + v2.date_from.secsTo(v2.date_to) }, 0);
                }, 0)); 
        var price = Math.round(price/3600);
        footerTime.text = time;
        footerPrice.text = price;
        }


    AppStyle { id: appStyle; }


    ApplicationMenu {
        id: appmenu;
        onStatusesChanged: {
            // console.log("---------------- PageCategories.onStatusesChanged: ");
            loadData(initpage.currentCategory);
            }
        }

    ListModel {
        id: timesheetsmodel;
        function appendArray(json) {
            for (var i=0; i<json.length; i++) { 
                var x = json[i];
                x.category        = Number(json[i].category);
                x.parent_category = Number(json[i].parent_category);
                append(x);
                }
            }
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


