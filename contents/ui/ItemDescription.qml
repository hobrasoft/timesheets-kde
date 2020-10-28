/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5


Item {
    id: root;
    // height: childrenRect.height;
    height: appStyle.textSize * 7;
    width: parent.width;

    property alias description: d.text; 

    MInputTextAreaField {
        id: d;
        anchors.fill: parent;
        label: qsTr("Description");
        }

}

