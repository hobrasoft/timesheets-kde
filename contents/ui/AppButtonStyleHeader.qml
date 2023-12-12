/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12


/**
@brief Styl pro zobrazení tlačítek
*/

ButtonStyle {
    id: root;
    property int role: 0;
    property int roleDefault: 0;
    property int roleDanger: 1;
    property real pixelSize: appStyle.labelSize;
    property string iconSource: "";
    property string iconColorEnabled: appStyle.textColor;
    property string iconColorDisabled: "lightgray";

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
        color: (role == roleDanger) ? ((control.pressed) ? "#60ffa0a0" : "#80ffa0a0")
                                    : ((control.pressed) ? "#60ffffff" : ((control.enabled) ? "#10ffffff" : "transparent" ) )
                                    ;
        border.color: (control.enabled) ? "#30ffffff" : "transparent";
        border.width: 1;
        radius: 0;

        Image {
            id: iconX;
            source: iconSource;
            fillMode: Image.PreserveAspectFit;
            anchors.fill: parent;
            anchors.margins: width/5;

            layer.enabled: true;
            layer.effect: ColorOverlay {
                anchors.fill: iconX;
                color: (control.enabled) ? iconColorEnabled : iconColorDisabled;
                }

            }

        }
}

