/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import "api.js" as Api

Item {
    id: initpage;
    anchors.fill: parent;

    property bool   kde: true;
    property int    currentCategory: 0;
    property int    parentCategory: 0;
    property int    userid: -1;
    property int    ticket: 0;
    property var    item: null;
    property var    allStatuses: [];
    property var    settings: null;
    property var    appStyle: null;

    ListModel {
        id: statuses;
        function load() {
            clear();
            var api = new Api.Api();
            api.onFinished = function(json) {
                allStatuses = [];
                for (var i=0; i<json.length; i++) {
                    if (json[i].ignored) { continue; }
                    allStatuses.push(json[i].status);
                    append({status: json[i].status, 
                            description: json[i].description, 
                            checked: !(json[i].closed),
                            abbreviation: json[i].abbreviation,
                            can_be_run: json[i].can_be_run,
                            closed: json[i].closed,
                            statusColor: json[i].color}
                            );
                    }
                }
            api.statusesAll();
            }
        }

    function all() {
        for (var i=0; i<statuses.count; i++) {
            // console.log("sssssssssssssssssssssssssssssss " + statuses.get(i).closed + " " + statuses.get(i).checked);
            if (statuses.get(i).closed && statuses.get(i).checked) { 
                return "true"; 
                }
            }
        return "false";
        }

    function loadStatuses() {
        statuses.load();
        }

    function statusesArray() {
        var x = new Array;
        for (var i=0; i<statuses.count; i++) {
            if (statuses.get(i).checked) {
                x.push(statuses.get(i).status);
                }
            }
        return x;
        }

    function loadPage(page, params) {
        if (initpage.item != null) {
            initpage.item.visible = false;
            initpage.item.x = 99999;
            initpage.item.destroy();
            }

        var pararams = (params == null) ? new Object() : params;
        var component = Qt.createComponent(page);
        if (component.status == Component.Error) {
            console.log("Error: ", component.errorString());
            }
        var instance = component.createObject(initpage, pararams);
        initpage.item = instance;
        }

    Timer {
        id: timer;
        interval: 1000;
        running: true;
        repeat: true;
        }

    Timer {
        id: initTimer;
        interval: 10;
        running: false;
        repeat: false;
        onTriggered: {
            var component = Qt.createComponent(initpage.kde ? "AppSettingsKde.qml" : "AppSettings.qml");
            initpage.settings = component.createObject(initpage);
            component = Qt.createComponent(initpage.kde ? "AppStyleKde.qml" : "AppStyle.qml");
            initpage.appStyle = component.createObject(initpage);
            if (!initpage.kde && initpage.settings.serverName == '') {
                loadPage("PageSettings.qml");
              } else {
                loadPage("PageCategories.qml");
                }
            }
        }

    Component.onCompleted: {
        Number.prototype.pad = function(size) {
            var s = String(this);
            while (s.length < (size || 2)) { s = "0" + s; }
            return s;
            };

        Number.prototype.formatHHMM = function() { if (isNaN(this)) { return ""; }
            var hh = Math.floor(this/3600);
            var mm = Math.floor((this - hh*3600)/60);
            var ss = Math.floor(this%60);
            return hh.pad(2)+":"+mm.pad(2);
            };

        Number.prototype.floor = function() {
            return Math.floor(this);
            }

        Number.prototype.formatHHMMSS = function() {
            if (isNaN(this)) { return ""; }
            var hh = Math.floor(this/3600);
            var mm = Math.floor((this - hh*3600)/60);
            var ss = Math.floor(this%60);
            return hh.pad(2)+":"+mm.pad(2)+":"+ss.pad(2);
            };

        Number.prototype.toLatitude = function() {
            if (isNaN(this)) { return ""; }
            var hh = Math.floor(this);
            var mm = Math.floor((this - hh)*60);
            var ss = Math.round(10*(this*60 - Math.floor(this*60)) * 60)/10;;
            return hh.pad(2) + "°" + mm.pad(2) + "'" + ss.pad(2) + '"' + ((this>0) ? " N" : " S");
            };

        Number.prototype.toLongitude = function() {
            if (isNaN(this)) { return ""; }
            var hh = Math.floor(this);
            var mm = Math.floor((this - hh)*60);
            var ss = Math.round(10*(this*60 - Math.floor(this*60)) * 60)/10;;
            return hh.pad(2) + "°" + mm.pad(2) + "'" + ss.pad(2) + '"' + ((this>0) ? " E" : " W");
            };

        Date.prototype.formatYYYYMMDDHHMM = function() {
            if (isNaN(this.getTime())) { return ""; }
            var yy = this.getFullYear();
            var mt = this.getMonth() + 1;
            var dd = this.getDate();
            var hh = this.getHours();
            var mm = this.getMinutes();
            return yy.pad(4)+"-"+mt.pad(2)+"-"+dd.pad(2)+" "+hh.pad(2)+":"+mm.pad(2);
            }

        Date.prototype.formatHHMM = function() {
            if (isNaN(this.getTime())) { return ""; }
            var hh = this.getHours();
            var mm = this.getMinutes();
            return hh.pad(2)+":"+mm.pad(2);
            }

        Date.prototype.formatHHMMSS = function() {
            if (isNaN(this.getTime())) { return ""; }
            var hh = this.getHours();
            var mm = this.getMinutes();
            var ss = this.getSeconds();
            return hh.pad(2)+":"+mm.pad(2)+":"+ss.pad(2);
            }

        Date.prototype.secsTo = function (date2) {
            if (isNaN(this.getTime())) { return ""; }
            if (isNaN(date2.getTime())) { return ""; }
            var d1 = this.getTime();
            var d2 = date2.getTime();
            return (d2 - d1) / 1000;
            }

        String.prototype.secsTo = function (date2) {
            var date1date = new Date(this);
            var date2date = new Date(date2);
            if (isNaN(date1date.getTime())) { return ""; }
            if (isNaN(date2date.getTime())) { return ""; }
            var d1 = date1date.getTime();
            var d2 = date2date.getTime();
            return (d2 - d1) / 1000;
            }

        String.prototype.formatYYYYMMDDHHMM = function() {
            var date = new Date(this);
            return date.formatYYYYMMDDHHMM();
            }

        Boolean.prototype.toString = function() {
            return  (this) ? "true" : "false";
            }

        initTimer.start();

        }

}

