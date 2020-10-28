/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.5


Item {
    id: xxxx;
    property string category: "";
    property var root: null;
    property bool canChangeCategory: true;
    property alias title: t1.text;

    width: parent.width;
    height: childrenRect.height;

    function appendCategory(x) {
        xxxx.category = x.category;
        catsmodel.append({"category": x.category, "description": x.description});
        }

    Button {
        id: buttonAdd;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.topMargin: appStyle.textSize / 5;
        text: qsTr("+");
        style: AppButtonStyle {}
        enabled: xxxx.canChangeCategory;
        onClicked: {
            dialog.category = xxxx.category;
            dialog.visible = true;
            }
        }

    Text {
        id: t1;
        anchors.top: parent.top;
        anchors.left: buttonAdd.right;
        anchors.right: parent.right;
        anchors.bottom: buttonAdd.bottom;
        leftPadding: appStyle.h4Size/2;
        verticalAlignment: Text.AlignVCenter;
        text: qsTr("Category");
        font.pixelSize: appStyle.labelSize;
        color: appStyle.textColor;
        }

    ListView {
        id: listview;
        anchors.top: t1.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: spacing;
        height: contentHeight;
        clip: true;
        model: catsmodel;
        spacing: 2;
        delegate: Item {
            width: content.width;
            height: childrenRect.height;
            Button {
                id: buttondel;
                style: AppButtonStyle {}
                text: "×";
                enabled: xxxx.canChangeCategory;
                anchors.left: parent.left;
                onClicked: {
                    catsmodel.deleteCategory(category);
                    }
                }
            Text {
                anchors.top: buttondel.top;
                anchors.left: buttondel.right;
                anchors.bottom: buttondel.bottom;
                rightPadding: appStyle.h4Size/2;
                leftPadding: appStyle.h4Size/2;
                text: description;
                font.pixelSize: appStyle.textSize;
                color: appStyle.textColor;
                verticalAlignment: Text.AlignVCenter;
                }
            }
        }


    ItemCategoryDialog { 
        id: dialog; 
        parent: root;
        onCategorySet: {
            xxxx.category = dialog.category;
            if (xxxx.category == '') { return; }
            catsmodel.append({"category": dialog.category, "description": dialog.description});
            }
        onNoCategoriesAvailable: {
            dialog.visible = false;
            buttonAdd.enabled = false;
            }
        }


    ListModel {
        id: catsmodel;

        function deleteCategory(category) {
            buttonAdd.enabled = true;
            for (var i=0; i<count; i++) {
                if (get(i).category == category) {
                    remove(i, count-i);
                    break;
                    }
                }
            if (count == 0) {
                xxxx.category = ""; 
              } else {
                xxxx.category = get(count-1).category;
                }
            dialog.category = xxxx.category;
            }

        }

}

