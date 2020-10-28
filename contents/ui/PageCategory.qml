/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.7
import QtQuick.Controls 1.4
import "api.js" as Api

Item {
    id: root;
    anchors.fill: parent;

    property int currentCategory: 0;
    property int parentCategory: 0;


    TimesheetsHeader {
        id: header;
        saveEnabled: description.text !== ''
        text: qsTr("New category");
        deleteVisible: true;
        deleteEnabled: currentCategory > 0;
        onSaveClicked: {
            saveData();
            }
        onCancelClicked: {
            initpage.loadPage("PageCategories.qml");
            }
        onDeleteClicked: {
            deleteDialog.visible = true;
            }
        }


    Item {
        id: body
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        ItemCategory {
            id: itemCategory;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            canChangeCategory: true;
            title: qsTr("Parent category");
            root: root;
            }

        MInputTextField {
            id: description;
            anchors.top: itemCategory.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Category description");
            }

        MInputTextField {
            id: price;
            anchors.top: description.bottom;
            anchors.topMargin: height/7;
            anchors.left: parent.left;
            anchors.right: parent.right;
            label: qsTr("Price");
            }

        }

    Component.onCompleted: {
        loadData();
        }


    QuestionDialog {
        text: qsTr("Do you really want to delete the category?\nWarning: This will delete all subcategories and theirs tickets!");
        id: deleteDialog;
        onAccepted: {
            var api = new Api.Api();
            api.onFinished = function() {
                initpage.loadPage("PageCategories.qml");
                };
            api.removeCategory(root.currentCategory);
            initpage.loadPage("PageCategories.qml");
            }
        }


    function loadData() {
        // Get the parent category
        if (parentCategory <= 0) {
            parentCategory.text = qsTr("/");
            }
        if (parentCategory > 0) {
            var api1 = new Api.Api();
            api1.onFinished = function(json) {
                price.text = json.price;
                var api2 = new Api.Api();
                api2.onFinished = function(json) {
                    json.map(function(x){itemCategory.appendCategory(x)});
                    }
                api2.categoriesToRoot(json.category);
                }
            api1.category(parentCategory);
            }

        if (currentCategory > 0) {
            var api2 = new Api.Api();
            api2.onFinished = function(json) {
                description.text = json.description;
                price.text = json.price;
                }
            api2.category(currentCategory);
            header.text = currentCategory;
            }
        }

    function saveData() {
        var api = new Api.Api();
        api.saveCategory({ category: currentCategory, parent_category: itemCategory.category, description: description.text, price: price.text });
        api.onFinished = function(json) {
            initpage.loadPage("PageCategories.qml");
            }
        }


}

