import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    id: root

    property var db

    signal loaded()

    function load()
    {
        db = LocalStorage.openDatabaseSync("UserSettingsDatabase", "1.0", "", 1000000/*1Mo*/, function(db) {
                db.transaction(function(tx) {
                    tx.executeSql('CREATE TABLE UserSettings(generalSettings TEXT)');
                    tx.executeSql('INSERT INTO UserSettings VALUES(?)', [ ''])

                    userSettings.resetToDefault()
                    saveQuery(tx)
                })
                db.changeVersion("", "1.0")
            }
        )
        db.transaction(
            function(tx) {
                // Create the database if it doesn't already exist
                var res = tx.executeSql('SELECT generalSettings from UserSettings');
                userSettings.setJsonSettings(res.rows.item(0).generalSettings)
            }
        )

        loaded()
    }

    function save()
    {
        //console.log(userSettings.jsonSettings())
        db.transaction(
            function(tx) {
                saveQuery(tx)
            }
        )
    }

    function saveQuery(tx) {
        var res = tx.executeSql('UPDATE UserSettings SET generalSettings=? WHERE 1', [userSettings.jsonSettings()]);
        if (!res)
        {
            console.log("Failed to save settings");
        }
    }

    Connections {
        target: userSettings
        onSettingsModified: {
            root.save()
        }
    }
}
