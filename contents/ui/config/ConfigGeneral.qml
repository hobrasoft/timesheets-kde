/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property alias cfg_serverUrl: serverUrl.text;
    property alias cfg_username:  username.text;
    property alias cfg_password:  password.text;

    Component.onCompleted: {
        username.text = plasmoid.configuration.username;
        password.text  = plasmoid.configuration.password;
        serverUrl.text  = plasmoid.configuration.serverUrl;
        }

    ColumnLayout {
        width: parent.width;
        anchors.left: parent.left;
        anchors.right: parent.right;

        Label {
            text: qsTr("Server URL");
            font.bold: true;
            }

        TextField {
            id: serverUrl;
            Layout.preferredWidth: parent.width;
            }

        Label {
            text: qsTr("User name");
            font.bold: true;
            }

        TextField {
            id: username;
            Layout.preferredWidth: parent.width;
            }

        Label {
            text: qsTr("Password");
            font.bold: true;
            }

        TextField {
            id: password;
            Layout.preferredWidth: parent.width;
            }
        }


}



