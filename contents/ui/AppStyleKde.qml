/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.2

/**
@brief Parametry potřebné pro nastylování aplikace
*/

Item {
    id:     appStyle;
    // anchors.fill: parent;

    property real ratio: 1000; // width * 1.6;

    property real buttonWidth: ratio / 10;
    property real inputHeight: labelSize * 2.5
    property string textColor: theme.textColor;
    property string textColorDisabled: "#80ffffff";
    property string backgroundColor: "transparent"; // theme.backgroundColor;

    property real h1Size: ratio / 22;
    property real h2Size: ratio / 24;
    property real h3Size: ratio / 26;
    property real h4Size: ratio / 29;
    property real h5Size: ratio / 32;
    property real h6Size: ratio / 36;
    property real textSize:  ratio / 52;
    property real labelSize: ratio / 48;
    property real smallSize: ratio / 56;
    property real smallerSize: ratio / 72;
    property real smalestSize: ratio / 92;

    function image(name) {
        return "qrc:///"+name;
        }

}

