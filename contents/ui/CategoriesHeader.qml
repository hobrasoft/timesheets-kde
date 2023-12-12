/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5
import QtGraphicalEffects 1.12


Item {
    id: root;
    visible: true;
    anchors.top: parent.top;
    anchors.left: parent.left;
    anchors.right: parent.right;

    height: appStyle.labelSize * 2.5;

    property alias title: t1.text;

    signal menuClicked();
    signal reloadClicked();
    signal filterClicked();

    Button {
        id: buttonMenu;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 0;
        text: qsTr("…");
        style: AppButtonStyleHeader {}
        height: appStyle.labelSize * 2.5;
        onClicked: {
            if (!enabled) { return; }
            menuClicked();
            }
        }

    Button {
        id: buttonReload;
        anchors.top: parent.top;
        anchors.right: buttonMenu.left;
        anchors.bottom: parent.bottom;
        anchors.rightMargin: 2;
        height: appStyle.labelSize * 2.5;
        onClicked: {
            if (!enabled) { return; }
            reloadClicked();
            }
        style: AppButtonStyleHeader {
            iconSource: "reload.svg";
            }
        }

    Button {
        id: buttonFilter;
        anchors.top: parent.top;
        anchors.right: buttonReload.left;
        anchors.bottom: parent.bottom;
        anchors.rightMargin: 2;
        height: appStyle.labelSize * 2.5;
        onClicked: {
            if (!enabled) { return; }
            filterClicked();
            }
        style: AppButtonStyleHeader {
            iconSource: "filter.svg";
            }

        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: buttonFilter.left;
        anchors.bottom: parent.bottom;
        anchors.leftMargin: appStyle.textSize*0.8;
        font.pixelSize: appStyle.labelSize;
        verticalAlignment: Text.AlignVCenter;
        wrapMode: Text.WordWrap;
        height: appStyle.labelSize * 2.5;
        color: appStyle.textColor;
        }

}



