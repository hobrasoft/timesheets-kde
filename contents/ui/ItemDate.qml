/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5


Item {
    id: root;
    height: childrenRect.height;
    width: parent.width;

    property date date: new Date();


    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        text: qsTr("Date and time");
        font.pixelSize: appStyle.labelSize;
        color: appStyle.textColor;
        }


    Text {
        id: t2;
        anchors.top: t1.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        font.pixelSize: appStyle.textSize;
        color: appStyle.textColor;
        text: date.formatYYYYMMDDHHMM();
        }


}

