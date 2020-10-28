/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

import QtQuick 2.7

/**
@brief Vlastní nastylovaná vstupní víceřádková textová oblast s popiskou pro formuláře
*/

Item {
    id: root;
    property alias label: lbl.text;                 ///< Text popisky
    property alias text: input.text;                ///< Editovaný text
    property alias readOnly: input.readOnly;        ///< Readonly položka je nastylovaná odlišně a nedá se měnit

    implicitWidth:  parent.width;
    implicitHeight: childrenRect.height;

    signal editingFinished();

    Text {
        id: lbl;
        font.pixelSize: appStyle.labelSize;
        font.family: "Helvetica";
        color: appStyle.textColor;
        }

    MInputTextArea {
        anchors.top: lbl.bottom;
        anchors.topMargin: 10;
        anchors.bottom: parent.bottom;
        id: input;
        width: parent.width;
        onEditingFinished: { root.editingFinished(); }
        }
}



