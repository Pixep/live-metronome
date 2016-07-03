import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    function load()
    {
        userSettings.load()
        var db = LocalStorage.openDatabaseSync("UserSettingsDatabase", "1.0", "", 1000000/*1Mo*/, function(db) {
                db.transaction(function(tx) {
                    tx.executeSql('CREATE TABLE UserSettings(generalSettings TEXT)');
                    tx.executeSql('INSERT INTO UserSettings VALUES(?)', [ '{"songs":[{"artist":"Tower of Power", "title":"Soul with capital S", "tempo":120}, {"title":"Soul Vaccination", "tempo":112}]}'])
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
    }
}
