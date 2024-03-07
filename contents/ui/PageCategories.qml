/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 2.7
import QtGraphicalEffects 1.12
import "api.js" as Api

Item {
    id: pageCategories;
    anchors.fill: parent;

    property bool somethingChecked: false;
    property var checkedTickets: [];
    property var timesheets: [];
    property var usersList: [];
    property var categoriesList: [];
    property bool allActiveTickets: false;


    function userName(id) {
        for (var i=0; i<usersList.length; i++) {
            if (usersList[i].user == id) {
                return usersList[i].name;
                }
            }
        return "????";
        }

    function categoriesToRoot(category, path) {
        if (typeof path == 'undefined') {
            return categoriesToRoot(category, new Array()).reverse().join(" » ");
            }
        for (var i=0; i<categoriesList.length; i++) {
            if (categoriesList[i].category == category) {
                console.log(JSON.stringify(categoriesList[i]));
                path.push(categoriesList[i].description);
                return categoriesToRoot(categoriesList[i].parent_category, path);
                }
            }
        return path;
        }

    function isTicket(data) {  
        if (typeof data !== 'object') { return false; }
        if (typeof data.ticket === 'undefined') { return false; }
        return true; 
        }           
                    
    function isCategory(data) {
        return !isTicket(data);
        }

    function isChecked(data) {
        if (typeof data !== 'object') { return false; }
        if (typeof data.ticket === 'undefined') { return false; }
        return checkedTickets.includes(data.ticket);
        }

    function extendTicketLine(data) {
        return allActiveTickets && isTicket(data);
        }
                    
    function canBeRun(data) {
        if (typeof data != 'object') { return false; }
        if (typeof data.ticket === 'undefined') { return false; }
        if (typeof data.statuses === 'undefined') { return false; }
        var statuses = data.statuses; 
        if (statuses.length === 0) { return false; }
        return statuses
              .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
              .filter(function(x){return !x.status_ignored;})
              .pop().status_can_be_run;
        }

    function status(data) {
        if (isCategory(data)) { return null; }
        if (typeof data.statuses === 'undefined') { return null; }
        if (Array.isArray(data.statuses) === false) { return null; } 
        var statuses = data.statuses;
        if (statuses.length == 0) { return null; } 
        statuses = statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
        statuses = statuses.filter(function(x){return !x.status_ignored;})
        var laststatus = statuses.pop();
        if (typeof laststatus.status === 'undefined') { return null; }
        return laststatus.status;
        }

    function statusColor(data) {
        var color = "transparent";
        if (isCategory(data)) { return color; }
        if (typeof data.statuses === 'undefined') { return color; }
        if (Array.isArray(data.statuses) === false) { return color; }
        var statuses = data.statuses;
        if (statuses.length == 0) { return color; }
        statuses = statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
        statuses = statuses.filter(function(x){return !x.status_ignored;})
        var status = statuses.pop();
        if (typeof status.status_color === 'undefined') { return color; }
        return status.status_color;
        }

    function statusDescription(data) {
        if (!isTicket(data)) { return ''; }
        if (typeof data.statuses === 'undefined') { return ''; }
        if (Array.isArray(data.statuses) === false) { return ''; }
        var statuses = data.statuses;
        if (statuses.length == 0) { return ''; }
        statuses = statuses.sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
        statuses = statuses.filter(function(x){return !x.status_ignored;})
        var status = statuses.pop();
        if (typeof status.status_description === 'undefined') { return ''; }
        return status.status_description;
        }

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

    function addStatusToSelectedTickets() {

        var previousStatuses = [];
        for (var i=0; i< listview.model.length; i++) {
            if (!isChecked(listview.model[i])) { continue; }
            var x = status(listview.model[i]);
            if (previousStatuses.includes(x)) { continue; }
            previousStatuses.push(x);
            }
        dialog.previousStatus = previousStatuses;
        dialog.description = '';
        dialog.category = initpage.currentCategory;
        dialog.visible = true;
        }

    function loadData(category) {
        busyIndicator.setBusy(true);
        if (category == -999) {
            category = initpage.parentCategory;
            }
        initpage.parentCategory = initpage.currentCategory;
        initpage.currentCategory = category;

        // Get the title
        allActiveTickets = (initpage.currentCategory == -1)
        if (allActiveTickets) {
            header.title = qsTr("All active tickets");
            }
        if (initpage.currentCategory == 0) {
            header.title = "/";
            }
        if (initpage.currentCategory > 0) {
            var api1 = new Api.Api();
            api1.onFinished = function(json) {
                // header.title = '(' + initpage.currentCategory + ') ' + json.description;
                header.title = json.description;
                initpage.parentCategory = json.parent_category;
                }
            api1.category(initpage.currentCategory);
            }

        var checkedTickets = new Array();
        var data = new Array();
        if (initpage.currentCategory === 0) {
            data.push({category: -1, parent_category: 0, description: qsTr('All active tickets'), categories: [], price: 0 });
            }

        if (allActiveTickets) {
            var api5 = new Api.Api();
            api5.onFinished = function(json) {
                usersList = json;
                }
            api5.users();

            var api6 = new Api.Api();
            api6.onFinished = function(json) {
                categoriesList = json;
                }
            api6.categories();
            }

        if (allActiveTickets) {
            data.push({category: 0, parent_category: 0, description: '..', categories: [], price: 0 });
            listview.model = data;
            var api4 = new Api.Api();
            api4.onFinished = function(json) {
                // filter selected categories
                var stats = initpage.statusesArray();
                json = json.filter(function(x) {
                        if (typeof x.statuses === 'undefined') { return true; }
                        if (x.statuses.length === 0) { return true; }
                        var x_status = x.statuses
                                .sort(function(a,b){return (a.date>b.date)?1:(a.date<b.date)?-1:0;})
                                .filter(function(s){return !s.status_ignored;}).pop().status;
                        return stats.includes(x_status);
                        });

                sumToFooter(json);
                listview.model = listview.model.concat(json);
                }
            api4.ticketsvwall();
            }

        if (!allActiveTickets) {
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                if (initpage.currentCategory != 0) {
                    data.push({category: -999, parent_category: 0, description: '..', categories: [], price: 0 });
                    }
                listview.model = data.concat(json);
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
                    sumToFooter(json);
                    listview.model = listview.model.concat(json);
                    }
                api3.ticketsvw(initpage.currentCategory);
                }
            api2.categoriestree(initpage.currentCategory);
            }
        }

    function sumToFooter(data) {
        if (typeof data !== 'object') { return; }
        if (typeof data.length != 'number') { return; }
        var time = 
            Number(data.reduce(function(a1, v1) {
                return a1 + v1.timesheets.reduce(function(a2, v2) { return a2 + Number(v2.date_from.secsTo(v2.date_to)) }, 0);
                }, 0)).formatHHMMSS();
        var price = 
            Number(data.reduce(function(a1, v1) {
                return a1 + v1.price * v1.timesheets.reduce(function(a2, v2) { return a2 + Number(v2.date_from.secsTo(v2.date_to)) }, 0);
                }, 0)); 
        var price = Math.round(price/3600);
        footerTime.text = time;
        footerPrice.text = price;
        busyIndicator.setBusy(false);
        }

    Background {}

    AppBusyIndicator { id: busyIndicator; }

    CategoriesHeader {
        id: header;
        onReloadClicked: {
            loadData(initpage.currentCategory);
            }
        onMenuClicked: {
            appmenu.visible = true;
            }
        onFilterClicked: {
            filtermenu.visible = true;
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

        delegate: Rectangle {
            width: listview.width;
            height: childrenRect.height;
            color: "#10ffffff";
            radius: 5;
            clip: true;
            property string iconColor: appStyle.textColor;
            Component.onCompleted: {
                iconColor = 
                       isCategory(modelData) ? appStyle.textColor 
                     : isTimesheetRunning(modelData) ? appStyle.textColor 
                     : "darkgray";
                }

            function edit(item) {
                if (isTicket(item)) {
                    initpage.loadPage ("PageTicket.qml", { ticket: item.ticket } );
                    return;
                    }
                loadData(item.category, item.parent_category);
                }

            function stopStart(item) {
                if (isTicket(item)) {
                    if (!canBeRun(item)) { return; }
                    toggleTimesheet(item);
                    iconColor = isTimesheetRunning(item) ? appStyle.textColor : "darkgray";
                    return;
                    }
                loadData(item.category, item.parent_category);
                }


            Rectangle {
                anchors.fill: parent;
                radius: parent.radius;
                color: statusColor(modelData);
                }

            Item {
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.leftMargin: appStyle.h4Size/7;
                anchors.rightMargin: appStyle.h4Size/7;
                height: icon.height + appStyle.h4Size;
                // Vede k property loop
                // height: childrenRect.height + appStyle.h4Size;


                Image {
                    id: icon;
                    source: isCategory(modelData) ? "folder.svg" 
                          : canBeRun(modelData) ? "stopwatch.svg"
                          : "";
                    height: tname.height * 1.1;
                    width: height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    fillMode: Image.PreserveAspectFit;


                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: icon;
                        color: iconColor;
                        source: icon;
                        }
                    }

                Text {
                    id: tuserid;
                    anchors.top: parent.top;
                    anchors.left: icon.right;
                    anchors.right: iconedit.left;
                    anchors.leftMargin: icon.height/5;
                    anchors.topMargin: isTicket(modelData) ? 0 : (parent.height-height)/2;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: extendTicketLine(modelData) ? modelData.date.formatYYYYMMDDHHMM() + ", " + userName(modelData.user) : "";
                    height:  extendTicketLine(modelData) ? tname.height : 0;
                    visible: extendTicketLine(modelData);
                    }

                Text {
                    id: tcategory;
                    anchors.top: tuserid.bottom;
                    anchors.left: icon.right;
                    anchors.right: iconedit.left;
                    anchors.leftMargin: icon.height/5;
                    anchors.topMargin: isTicket(modelData) ? 0 : (parent.height-height)/2;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: extendTicketLine(modelData) ? categoriesToRoot(modelData.category) : "";
                    height:  extendTicketLine(modelData) ? tname.height : 0;
                    visible: extendTicketLine(modelData);
                    }

                Text {
                    id: tname;
                    anchors.top: extendTicketLine(modelData) ? tcategory.bottom : parent.top;
                    anchors.left: icon.right;
                    anchors.right: iconedit.left;
                    anchors.leftMargin: icon.height/5;
                    anchors.topMargin: isTicket(modelData) ? 0 : (parent.height-height)/2;
                    font.pixelSize: appStyle.labelSize;
                    color: appStyle.textColor;
                    text: modelData.description;
                    }

                Item {
                    id: line2;
                    anchors.top: tname.bottom;
                    anchors.left: tname.left;
                    // anchors.bottom: parent.bottom;
                    visible: isTicket(modelData);

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
                        text: typeof modelData !== 'undefined' && typeof modelData.timesheets !== 'undefined'
                              ? Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                    return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                    }, 0)).formatHHMMSS()
                              : "";

                        Component.onCompleted: {
                            if (!isTicket(modelData)) { return; }
                            timer.triggered.connect(function() {
                                if (typeof modelData == 'undefined') { return; }
                                if (typeof modelData.timesheets == 'undefined') { return; }
                                var seconds = Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                            if (typeof currentValue == 'undefined') { return accumulator; }
                                            if (typeof currentValue.date_to == 'undefined') { return accumulator; }
                                            if (typeof currentValue.date_from == 'undefined') { return accumulator; }
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
                        text: isTicket(modelData) && typeof modelData.timesheets.length === 'number' 
                                ? Math.round(Number(modelData.timesheets.reduce(function(accumulator, currentValue) {
                                        return accumulator + currentValue.date_from.secsTo(currentValue.date_to);
                                        }, 0)) * modelData.price / 3600)
                                : '';
                        }

                    Text {
                        id: lbl5;
                        font.pixelSize: appStyle.smallSize;
                        anchors.top: lbl2.top
                        anchors.left: lbl4.right;
                        anchors.leftMargin: appStyle.smallSize;
                        color: appStyle.textColor;
                        text:  statusDescription(modelData);
                        }

                    }

                Image {
                    id: iconedit;
                    source: "edit.svg";
                    height: appStyle.h4Size;
                    fillMode: Image.PreserveAspectFit;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: checker.left;
                    anchors.rightMargin: width/3;
                    visible: isTicket(modelData) && initpage.kde;

                    layer.enabled: true;
                    layer.effect: ColorOverlay {
                        anchors.fill: iconedit;
                        color: appStyle.textColor;
                        source: iconedit;
                        }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            edit(modelData);
                            }
                        }
                    }

                MInputCheckbox {
                    id: checker;
                    // height: tname.height;
                    // width: height;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    anchors.rightMargin: 0;
                    visible: isTicket(modelData);
                    checked: isChecked(modelData);
                    onClicked: {
                        if (checker.checked && !isChecked(modelData)) {
                            checkedTickets.push(modelData.ticket);
                            somethingChecked = checkedTickets.length > 0;
                            return;
                            }
                        if (!checker.checked && isChecked(modelData)) {
                            const index = checkedTickets.indexOf(modelData.ticket);
                            if (index < 0) { return; }
                            checkedTickets.splice(index, 1);
                            somethingChecked = checkedTickets.length > 0;
                            return;
                            }
                            
                        }
                    }

                MouseArea {
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: iconedit.left;
                    anchors.bottom: parent.bottom;
                    anchors.rightMargin: 10;

                    onClicked: {
                        stopStart(modelData);
                        }

                    onPressAndHold: {
                        if (initpage.kde) { return; }
                        edit(modelData);
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
        initpage.loadStatuses();
        var api7 = new Api.Api();
        api7.onFinished = function(json) {
            initpage.userid = json.userid;
            loadData(initpage.currentCategory);
            }
        api7.authenticate(initpage.username, initpage.password);
        }

    ApplicationMenu {
        id: appmenu;
        }

    FilterMenu {
        id: filtermenu;
        onStatusesChanged: {
            loadData(initpage.currentCategory);
            }
        }

    ItemStatusDialog { 
        id: dialog; 
        parent: pageCategories;
        onStatusAdded: {
            for (var i=0; i<checkedTickets.length; i++) {
                var api = new Api.Api();
                api.onFinished = function(json) {
                    };
                api.onError = function(json) {
                    };
                api.appendStatus({ "ticket": checkedTickets[i], "status": dialog.status, "description": dialog.description});
                }
            timerReload.start();
            }
        Timer {
            id: timerReload;
            interval: 1000;
            onTriggered: {
                checkedTickets = new Array();
                loadData(initpage.currentCategory);
                }
            }
        }
        


/*
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
*/

}


