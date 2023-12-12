/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5

Rectangle {
    id: root;
    visible: true;
    anchors.fill: parent;

    Background{}

    ColumnLayout {
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: appStyle.textSize*0.8;
        anchors.leftMargin: appStyle.textSize*0.8;
        anchors.rightMargin: appStyle.textSize*0.8;

        spacing: appStyle.textSize*1.5;

        Text {
            Layout.fillWidth: true;
            text: qsTr("Could not login to server. The user name or password are invalid!");
            font.pixelSize: appStyle.textSize*1.2;
            color: "tomato";
            wrapMode: Text.WordWrap;
            }

        Text {
            Layout.fillWidth: true;
            text: qsTr("Please, check your user name and password and repeat the action again.");
            font.pixelSize: appStyle.textSize;
            wrapMode: Text.WordWrap;
            }

        Button {
            Layout.fillWidth: true;
            Layout.leftMargin: appStyle.textSize * 5;
            style: AppButtonStyle {}
            text: qsTr("Back");
            height: appStyle.textSize * 2.5
            onClicked: {
                pageLoader.source = "PageSettings.qml";
                }
            }


        }

}



