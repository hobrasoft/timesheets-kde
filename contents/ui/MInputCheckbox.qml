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
            implicitWidth: appStyle.h5Size;
            implicitHeight: appStyle.h5Size;
            radius: height/8
            color: control.pressed ? appStyle.textColor : "transparent";
            border.color: appStyle.textColor;
            border.width: 3;
            Rectangle {
                visible: control.checkedState == Qt.Checked;
                color:  appStyle.textColor;
                radius: height/8;
                anchors.margins: 7;
                anchors.fill: parent;
                }
            Rectangle {
                visible: control.checkedState == Qt.PartiallyChecked;
                border.color: appStyle.textColor;
                border.width: 3;
                color: "transparent";
                radius: height/8;
                anchors.margins: 9;
                anchors.fill: parent;
                }


            }
        }
}

