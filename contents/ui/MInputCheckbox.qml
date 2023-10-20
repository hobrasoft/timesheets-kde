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

CheckBox {
    id: root;
    style: CheckBoxStyle {
        indicator: Rectangle {
            implicitWidth: 30;
            implicitHeight: 30;
            radius: height/8
            color: control.pressed ? "#30ffffff" : "transparent";
            border.color: "lightgray";
            border.width: 3;
            Rectangle {
                visible: control.checkedState == Qt.Checked;
                color: parent.border.color;
                radius: height/8;
                anchors.margins: 7;
                anchors.fill: parent;
                }
            Rectangle {
                visible: control.checkedState == Qt.PartiallyChecked;
                border.color: "#80808080";
                border.width: 3;
                color: "transparent";
                radius: height/8;
                anchors.margins: 9;
                anchors.fill: parent;
                }


            }
        }
}

