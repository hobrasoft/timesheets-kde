
class Api {
    constructor() {
        this.onFinished = function(data) { }
        this.onError = function(errorText) { console.log("error1: " + errorText); }

        this.get = function(url, params) {
            var rq = new XMLHttpRequest();
            var todleto = this;
            rq.onerror = function() {
                console.log("error2: " + rq.responseText);
                todleto.onError(rq.responseText);
                };
            rq.onreadystatechange = function() {
                if (rq.readyState === XMLHttpRequest.DONE && rq.status == 200) {
                    todleto.onFinished(JSON.parse(rq.responseText));
                    }
                };
            params = typeof params === 'undefined' ? '' : '&'+params;
            var completeUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName + settings.apiPath + url + "?user=" + settings.username + "&password=" + settings.password + params;
            console.log(completeUrl);
            rq.open("GET", completeUrl, true);
            rq.send();
            }

        this.put = function(url, data) {
            var rq = new XMLHttpRequest();
            var todleto = this;
            console.log(data);
            rq.onerror = function() {
                console.log("error3: " + rq.responseText);
                todleto.onError(rq.responseText);
                };
            rq.onreadystatechange = function() {
                if (rq.readyState === XMLHttpRequest.DONE && (rq.status == 200 || rq.status == 204)) {
                    todleto.onFinished(JSON.parse(rq.responseText));
                    }
                };
            var completeUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName + settings.apiPath + url + "?user=" + settings.username + "&password=" + settings.password;
            rq.open("PUT", completeUrl, true);
            rq.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
            rq.send(data);
            }

        this.delete = function(url) {
            var rq = new XMLHttpRequest();
            var todleto = this;
            rq.onerror = function() {
                console.log("error4: " + rq.responseText);
                todleto.onError(rq.responseText);
                };
            rq.onreadystatechange = function() {
                if (rq.readyState === XMLHttpRequest.DONE && (rq.status == 200 || rq.status == 201)) {
                    todleto.onFinished(JSON.parse(rq.responseText));
                    }
                };
            var completeUrl = (settings.useSSL ? "https://" : "http://") + settings.serverName + settings.apiPath + url + "?user=" + settings.username + "&password=" + settings.password;
            rq.open("DELETE", completeUrl, true);
            rq.send();
            }

        this.category = function (c) { this.get("categories/"+c); }
        this.categories = function () { this.get("categories"); }
        this.categoriesToRoot = function (c) { this.get("categoriestoroot/"+c); }
        this.categoriestree = function (category) { this.get("categoriestree/"+category,"maxdepth=0"); }
        this.ticketsvw = function (category) { this.get("ticketsvw", "category=" + category + "&all=" + initpage.all()); }
        this.ticketsvwall = function () { this.get("ticketsvw", "all=" + initpage.all()); }
        this.ticketvw = function (ticket) { this.get("ticketsvw/"+ticket+"?all=true"); }
        this.saveCategory = function (c) { this.put("categories/", JSON.stringify(c)); }
        this.statuses = function (category, prevstatus) { this.get("statuses", "category="+category+"&previousStatuses="+JSON.stringify(prevstatus)); }
        this.users = function (user) { if (typeof user !== 'undefined') { this.get("users/" + user); } else { this.get("users"); } }
        this.saveTicket = function(t) { this.put("ticketsvw/", JSON.stringify(t)); }
        this.startTimesheet = function(t) { this.get("timesheet/start/" + t); }
        this.stopTimesheet = function(t) { this.get("timesheet/stop/" + t); }
        this.removeTicket = function(t) { this.delete("tickets/" + t); }
        this.removeCategory = function(c) { this.delete("categories/" + c); }
        this.authenticate = function(user, password) { this.get("authenticate"); }
        this.statusesAll = function () { this.get("statuses"); }
        this.appendStatus = function (c) { c.user = initpage.userid; c.date = new Date(); this.put("ticketstatus/", JSON.stringify(c)); }
        this.serverAbout = function () { this.get("server/about"); }
        this.removeOverview = function(o) { this.delete("overview/" + o); }
        this.overview = function (category, statuses) { 
                    if (typeof category !== 'undefined') 
                        { this.get("overview/" + category,  "statuses=" + statuses.join(",")); }
                        else
                        { this.get("overview"); }
                    }
        }
}


