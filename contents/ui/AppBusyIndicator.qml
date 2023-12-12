/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.12


BusyIndicator {
    id: root;
    z: 99999;
    running: false;
    visible: false;
    anchors.centerIn: parent;

    layer.enabled: true;
    layer.effect: ColorOverlay {
        anchors.fill: root;
        color: appStyle.textColor;
        source: root;
        }


    function setBusy(busy) {
        visible = busy;
        running = busy;
        }

    }

