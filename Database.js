// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

function dbInit()
{
    let db = LocalStorage.openDatabaseSync("inventaire", "", "Gestion des costumes de Galet Jade", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS costume (id text,type text,description text, genre text, mode text, epoque text, couleur text, taille text, etat text, emplacement text, emprunteur text, date_emprunt text, date_versement_caution text, date_retour text, date_remoursement_caution text, commentaires text)')
            console.log("Creating table in database: " )
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("inventaire", "",
                                               "Gestion des costumes de Galet Jade", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function dbInsert(Id, Type, Description)
{
    let db = dbGetHandle()
    let rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO costume VALUES("","","","","","","","","","","","","","","","")')
        let result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbReadAll()
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
                'SELECT rowid,id,type,description, genre, mode, epoque, couleur, taille, etat, emplacement, emprunteur, date_emprunt, date_versement_caution, date_retour, date_remoursement_caution, commentaires FROM costume order by rowid desc')
        listModel.clear()
        for (let i = 0; i < results.rows.length; i++) {
            listModel.append({
                                 id: results.rows.item(i).rowid,
                                 type:results.rows.item(i).type,
                                 description:results.rows.item(i).description,
                                 genre:results.rows.item(i).genre,
                                 mode:results.rows.item(i).mode,
                                 epoque:results.rows.item(i).epoque,
                                 couleur:results.rows.item(i).couleur,
                                 taille:results.rows.item(i).taille,
                                 etat:results.rows.item(i).etat,
                                 emplacement:results.rows.item(i).emplacement,
                                 emprunteur:results.rows.item(i).emprunteur
                             })
            console.log("Find in db: " + listModel.get(listModel.count-1).type)
        }
    })
}

function dbUpdate(id, type, description, genre, mode, epoque, couleur, taille, etat, emplacement, emprunteur)
{
    let db = dbGetHandle()
    console.log("Change in db the id  " + id)
    db.transaction(function (tx) {
        tx.executeSql(
                    'update costume set id=?, type=?, description=?, genre=?, mode=?, epoque=?, couleur=?, taille=?, etat=?, emplacement=?, emprunteur=?, date_emprunt=?, date_versement_caution=?, date_retour=?, date_remoursement_caution=?, commentaires=? where rowid = ?',
                    [id, type, description, genre, mode, epoque, couleur, taille, etat, emplacement, emprunteur, "", "", "", "", "", id])
    })
}

function dbDeleteRow(Prowid)
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        console.log("Delete in db the id  " + Prowid)
        tx.executeSql('delete from costume where rowid = ?', [Prowid])
    })
}
