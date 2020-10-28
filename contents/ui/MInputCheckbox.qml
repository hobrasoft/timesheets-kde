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
    style: CheckBoxStyle {
        indicator: Rectangle {
            implicitWidth: 40;
            implicitHeight: 40;
            radius: 10;
            color: control.pressed ? "#20ffffff" : "#60ffffff";
            border.color: "lightgray";
            border.width: 2;
            Rectangle {
                visible: control.checkedState == Qt.Checked;
                color: "#80808080";
                radius: 8;
                anchors.margins: 7;
                anchors.fill: parent;
                }
            Rectangle {
                visible: control.checkedState == Qt.PartiallyChecked;
                border.color: "#80808080";
                border.width: 3;
                color: "transparent";
                radius: 8;
                anchors.margins: 8;
                anchors.fill: parent;
                }


            }
        }
}

