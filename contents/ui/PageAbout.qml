/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import "api.js" as Api
import "version.js" as Version

Item {
    id: root;
    visible: true;
    anchors.fill: parent;
    focus: true;

    property string server_name: "";
    property string server_description: "";
    property string server_git_branch: "";
    property string server_git_commit: "";
    property string server_qt_version: "";
    property string server_version: "";

    Background{}

    TimesheetsHeader {
        id: header;
        saveVisible: false;
        text: qsTr("About application");
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        }

    Component.onCompleted: {
        busyIndicator.setBusy(true);
        var api = new Api.Api();
        api.onFinished = function(json) {
            server_name = json.name ;
            server_description = json.description ;
            server_git_commit = json.git_commit ;
            server_git_branch = json.git_branch ;
            server_qt_version = json.qt_version ;
            server_version = json.version;
            busyIndicator.setBusy(false);
            };
        api.serverAbout();
        }

    ColumnLayout {
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: appStyle.textSize*0.8;
        anchors.leftMargin: appStyle.textSize*0.8;
        anchors.rightMargin: appStyle.textSize*0.8;
        spacing: appStyle.textSize * 0.5;

        Text {
            Layout.fillWidth: true;
            text: settings.serverName;
            font.pixelSize: appStyle.h4Size;
            color: appStyle.textColor;
            }
        Text {
            Layout.fillWidth: true;
            text: server_description;
            font.pixelSize: appStyle.h4Size;
            color: appStyle.textColor;
            }

        Spacer { Layout.fillWidth: true; }

        Text {
            Layout.fillWidth: true;
             text: qsTr("Version") + ": " + Version.version;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
             text: qsTr("Qt version") + ": " + Version.qtVersion;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Git branch") + ": " + Version.gitBranch;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Git commit") + ": " + Version.gitCommit;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

/*
        Text {
            Layout.fillWidth: true;
            // text: qsTr("SSL support") + ": " + (// Version.supportsSsl ? qsTr("Yes") : qsTr("No"));
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }
*/

        Spacer { Layout.fillWidth: true; }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Server version") + ": " + server_version;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Server Qt version") + ": " + server_qt_version;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Server Git branch") + ": " + server_git_branch;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Server Git commit") + ": " + server_git_commit;
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Spacer { Layout.fillWidth: true; }

        Text {
            Layout.fillWidth: true;
            text: qsTr("© 2023 Hobrasoft s.r.o.");
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("https://www.hobrasoft.cz/timesheets");
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    Qt.openUrlExternally("https://www.hobrasoft.cz/timesheets");
                    }
                }
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("info@hobrasoft.cz");
            font.pixelSize: appStyle.labelSize;
            color: appStyle.textColor;
            }

        Image {
            Layout.fillWidth: true;
            Layout.rightMargin: root.width/2;
            source: "logo-hobrasoft.svg";
            fillMode: Image.PreserveAspectFit;
            }

        }

    AppBusyIndicator { id: busyIndicator; }

}



