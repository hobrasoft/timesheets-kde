/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */

/**
@brief Vlastní nastylovaná vstupní víceřádková textová oblast pro psaní románů
*/

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root;
    width: 300;
    height: childrenRect.height;
    property alias text: input.text;                ///< Editovaný text
    property alias readOnly: input.readOnly;        ///< Readonly položka je nastylovaná odlišně a nedá se měnit

    signal editingFinished();

    Rectangle {
        anchors.fill: parent;
        color: Qt.tint(appStyle.backgroundColor, "#20404040");
        radius: 5;
        }

    TextArea {
        id: input;
        // color: (root.readOnly) ? Qt.tint(appStyle.textColor, "#80808080") : appStyle.textColor;
        font.pixelSize: appStyle.textSize;
        font.bold: false;
        anchors.fill: parent;
        textMargin: 11;
        onEditingFinished: { parent.editingFinished(); }
        backgroundVisible: false;
        frameVisible: false;
        style: TextAreaStyle {
            renderType: Text.QtRendering;
            textColor: appStyle.textColor;
            selectionColor: "green";
            backgroundColor: "transparent";
            }
        }

}


