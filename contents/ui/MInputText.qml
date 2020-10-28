/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

/**
@brief Vlastní nastylované vstupní textové pole
*/

import QtQuick 2.7

Item {
    width: 300;
    height: appStyle.inputHeight;

    property alias text: input.text;                            ///< Editovaný text
    property alias echoMode: input.echoMode;                    ///< Umožňuje zapnout/vypnout zobrazování znaků (u hesel)
    property alias readOnly: input.readOnly;                    ///< Readonly položky je nastylovaná odlišně a nedá se měnit
    property alias inputMethodHints: input.inputMethodHints;    ///< Nápověda pro Android, jakou vstupní klávesnici má použít

    signal editingFinished();

    Rectangle {
        anchors.fill: parent;
        color: (parent.readOnly) ? "transparent" : "#10ffffff";
        radius: 5;
        }

    TextInput {
        id: input;
        color: appStyle.textColor;
        selectionColor: "green";
        font.pixelSize: appStyle.labelSize;
        font.bold: false;
        width: parent.width-20;
        anchors.centerIn: parent;
        onEditingFinished: { parent.editingFinished(); }
        }

}


