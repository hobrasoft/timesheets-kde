/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

import QtQuick 2.7

/**
@brief Vlastní nastylované vstupní textové pole s popiskou pro formuláře
*/

Item {
    id: root;
    property alias label: lbl.text;                             ///< Text popisky
    property alias text: input.text;                            ///< Editovaný text
    property alias echoMode: input.echoMode;                    ///< Umožňuje zapnout/vypnout zobrazování znaků (u hesel)
    property alias readOnly: input.readOnly;                    ///< Readonly položky je nastylovaná odlišně a nedá se měnit
    property alias inputMethodHints: input.inputMethodHints;    ///< Nápověda pro Android, jakou vstupní klávesnici má použít

    implicitWidth:  parent.width;
    implicitHeight: childrenRect.height;

    signal editingFinished();

    Text {
        id: lbl;
        font.pixelSize: appStyle.labelSize;
        font.family: "Helvetica";
        color: appStyle.textColor;
        }

    MInputText {
        anchors.top: lbl.bottom;
        anchors.topMargin: 10;
        id: input;
        width: parent.width;
        onEditingFinished: { root.editingFinished(); }
        }
}



