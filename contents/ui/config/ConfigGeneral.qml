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
    property alias cfg_serverName: serverName.text;
    property alias cfg_username:  username.text;
    property alias cfg_password:  password.text;

    Component.onCompleted: {
        username.text = plasmoid.configuration.username;
        password.text  = plasmoid.configuration.password;
        serverName.text  = plasmoid.configuration.serverName;
        }

    ColumnLayout {
        width: parent.width;
        anchors.left: parent.left;
        anchors.right: parent.right;

        Label {
            text: qsTr("Server name");
            font.bold: true;
            }

        TextField {
            id: serverName;
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



