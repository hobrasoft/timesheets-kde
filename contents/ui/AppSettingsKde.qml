import QtQuick 2.7
// import QtQuick.Controls 1.4


Item {
    // fileName: "prace.conf";
    property bool   useSSL:     true;
    property string serverName: plasmoid.configuration.serverName;
    property string username:   plasmoid.configuration.username;
    property string password:   plasmoid.configuration.password;
    property string apiPath:    "/api/v1/";
    property bool   show_price: true;
    property bool   multiple_timesheets: false;
    property bool   can_change_category: true;
    property bool   can_edit_categories: true;
    property bool   show_multiple_timesheets: true;
    property bool   show_show_price: true;
    property bool   show_can_change_category: true;
    property bool   show_can_edit_categories: true;

    // Not accessible from any form
    property string server_description: "";
    property string server_version: "";
    property string server_qt_version: "";
    property string server_git_branch: "";
    property string server_git_commit: "";

    }

