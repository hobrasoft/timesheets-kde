/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

/**
@brief Jednoduchý nastylovaný checkbox
*/

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Item {
    id: root;
    height: appStyle.inputHeight;

    property alias label: lbl.text;                             ///< Text popisky
    property alias checkedState: input.checkedState;            ///< Stav zaškrtnutí
    property alias partiallyCheckedEnabled: input.partiallyCheckedEnabled; 
    property bool readOnly: false;

    implicitWidth:  parent.width;
    implicitHeight: childrenRect.height;

    Rectangle {
        anchors.fill: parent;
        color: Qt.tint(appStyle.backgroundColor, "#80808080");
        // border.color: (!parent.enabled || parent.readOnly) ? "lightgray" : "darkgray";
        // border.width: 2;
        radius: 0;
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                // input["clicked"] = mouse; // doprdele
                console.log( input.checkedState + ' ' +  Qt.Unchecked +  ' ' + Qt.PartiallyChecked +  ' ' + Qt.Checked);
                if (input.checkedState == Qt.Unchecked && input.partiallyCheckedEnabled ) { input.checkedState = Qt.PartialyChecked; return; }
                if (input.checkedState == Qt.Unchecked) { input.checkedState = Qt.Checked; return; }
                if (input.checkedState == Qt.PartiallyChecked ) { input.checkedState = Qt.Checked; return; }
                if (input.checkedState == Qt.Checked) { input.checkedState = Qt.Unchecked; return; }
                }
            }
        }

    MInputCheckbox {
        id: input;
        anchors.left: parent.left;
        anchors.leftMargin: parent.height/5;
        anchors.verticalCenter: parent.verticalCenter;
        onCheckedStateChanged: { root.checkedStateChanged(); }
        }

    Text {
        id: lbl;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter;
        font.pixelSize: appStyle.labelSize;
        font.family: "Helvetica";
        horizontalAlignment: Text.AlignHCenter;
        color: (parent.enabled) ? appStyle.textColor : appStyle.textColorDisabled;

        }
}


