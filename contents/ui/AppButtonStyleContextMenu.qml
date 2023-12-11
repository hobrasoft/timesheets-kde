/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4

/**
@brief Styl pro zobrazení tlačítek
*/

ButtonStyle {
    id: root;
    property int role: 0;
    property int roleDefault: 0;
    property int roleDanger: 1;
    property real pixelSize: appStyle.labelSize;

    label: Text {
        id: text;
        rightPadding: appStyle.h4Size/2;
        leftPadding: appStyle.h4Size/2;
        text: control.text;
        clip: true;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignHCenter;
        font.pixelSize: root.pixelSize;
        color: (control.enabled) ? appStyle.textColor : appStyle.textColorDisabled;
        }

    background: Rectangle {
        color: (role == roleDanger) ? ((control.pressed) ? Qt.tint(appStyle.backgroundColor, "#20808080") : Qt.tint(appStyle.backgroundColor, "#80ff8080"))
                                    : ((control.pressed) ? Qt.tint(appStyle.backgroundColor, "#20808080") : Qt.tint(appStyle.backgroundColor, "#80808080"))
                                    ;
        radius: 0;
        }
}

