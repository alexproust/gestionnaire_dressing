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

function dbInsert()
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
                            "id": results.rows.item(i).rowid,
                            "type":results.rows.item(i).type,
                            "description":results.rows.item(i).description,
                            "genre":results.rows.item(i).genre,
                            "mode":results.rows.item(i).mode,
                            "epoque":results.rows.item(i).epoque,
                            "couleur":results.rows.item(i).couleur,
                            "taille":results.rows.item(i).taille,
                            "etat":results.rows.item(i).etat,
                            "emplacement":results.rows.item(i).emplacement,
                            "emprunteur":results.rows.item(i).emprunteur,
                            "date_versement_caution": results.rows.item(i).date_versement_caution,
                            "date_emprunt": results.rows.item(i).date_emprunt,
                            "date_retour": results.rows.item(i).date_retour,
                            "date_remboursement_caution": results.rows.item(i).date_remoursement_caution,
                            "commentaires": results.rows.item(i).commentaires
                             })
            console.log("Find in db: " + listModel.get(listModel.count-1).type)
        }
        console.log("db size after update: " + listModel.count)
    })
}


function dbSet(id, costume)
{
    let db = dbGetHandle()
    console.log("Change in db the id  " + id + " type : " + costume.type)
    db.transaction(function (tx) {
        tx.executeSql(
                    'update costume set id=?, type=?, description=?, genre=?, mode=?, epoque=?, couleur=?, taille=?, etat=?, emplacement=?, emprunteur=?, date_emprunt=?, date_versement_caution=?, date_retour=?, date_remoursement_caution=?, commentaires=? where rowid = ?',
                    [id, costume.type, costume.description, costume.genre, costume.mode, costume.epoque, costume.couleur, costume.taille, "", "", "", "", "", "", "", "", id])
    })
}

function dbUpdate(costume)
{
    let db = dbGetHandle()
    console.log("Change in db the id  " + costume.id + " type : " + costume.type + " description : " + costume.description)
    db.transaction(function (tx) {
        tx.executeSql(
                    'update costume set id=?, type=?, description=?, genre=?, mode=?, epoque=?, couleur=?, taille=?, etat=?, emplacement=?, emprunteur=?, date_emprunt=?, date_versement_caution=?, date_retour=?, date_remoursement_caution=?, commentaires=? where rowid = ?',
                    [costume.id, costume.type, costume.description, costume.genre, costume.mode, costume.epoque, costume.couleur, costume.taille, costume.etat, costume.emplacement, costume.emprunteur, costume.date_emprunt, "", costume.date_retour, "", "", costume.id])
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

function jsUpdate(adherents)
{
    listEmprunterModel.clear()
    for (let i = 0; i < adherents.length; i++) {
        listEmprunterModel.append({
                        "name": adherents[i]
                         })
        console.log("Find in adherent list: " + listEmprunterModel.get(listEmprunterModel.count-1).name)
    }
    console.log("Adherent model size after update: " + listEmprunterModel.count)
}
