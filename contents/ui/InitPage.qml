/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: initpage;
    anchors.fill: parent;

    property string serverUrl: plasmoid.configuration.serverUrl;
    property string apiPath:   "/api/v1/";
    property string username:  plasmoid.configuration.username;
    property string password:  plasmoid.configuration.password;

    property int    currentCategory: 0;
    property int    parentCategory: 0;
    property int    userid: 2;
    property bool   show_price: true;
    property bool   all: false;

    property int ticket: 0;

    property var item: null;

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

    AppStyle { id: appStyle; }

    Timer {
        id: timer;
        interval: 1000;
        running: true;
        repeat: true;
        }

    Component.onCompleted: {
        Number.prototype.pad = function(size) {
            var s = String(this);
            while (s.length < (size || 2)) { s = "0" + s; }
            return s;
            };

        Number.prototype.formatHHMM = function() {
            if (isNaN(this)) { return ""; }
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

        loadPage("PageCategories.qml");
        }

}

