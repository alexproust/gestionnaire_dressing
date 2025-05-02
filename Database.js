// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

function dbInit()
{
    let db = LocalStorage.openDatabaseSync("inventaire", "", "Gestion des costumes de Galet Jade", 1000000)
    try {
        db.transaction(function (tx) {
            console.log("Creating database if not existing" )
            tx.executeSql('CREATE TABLE IF NOT EXISTS costume (id text,type text,description text, genre text, mode text, epoque text, couleur text, taille text, etat text, emplacement text, emprunteur text, date_emprunt text, date_retour text, commentaires text)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS adherent (name text, mail text, phone text, date_versement_caution text, date_remboursement_caution text, montant_caution text)')
        })
    } catch (err) {
        console.error("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("inventaire", "",
                                               "Gestion des costumes de Galet Jade", 1000000)
    } catch (err) {
        console.error("Error opening database: " + err)
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
        console.log("Insert in database with id : " + rowid)
    })
    return rowid;
}

function dbReadAllForList()
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
                'SELECT rowid,id,type, genre, couleur, taille FROM costume order by rowid desc')
        listModelTile.clear()
        console.log("Find in db: " + results.rows.length + " costumes")
        for (let i = 0; i < results.rows.length; i++) {
            listModelTile.append({
                            "id": Math.round(results.rows.item(i).id),
                            "type":results.rows.item(i).type,
                            "genre":results.rows.item(i).genre != null ? results.rows.item(i).genre : "",
                            "couleur":results.rows.item(i).couleur != null ? results.rows.item(i).couleur : "",
                            "taille":results.rows.item(i).taille != null ? results.rows.item(i).taille : "",
                             })
            console.log("Cache memoring : " + Math.round((i / results.rows.length)*100) + "%")
        }
        console.log("db size after update: " + listModelTile.count)
    })
}

function dbReadAll()
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
                'SELECT rowid,id,type,description, genre, mode, epoque, couleur, taille, etat, emplacement, emprunteur, date_emprunt, date_retour, commentaires FROM costume order by rowid desc')
        listModel.clear()
        console.log("Find in db: " + results.rows.length + " costumes")
        for (let i = 0; i < results.rows.length; i++) {
            listModel.append({
                            "id": Math.round(results.rows.item(i).id),
                            "type":results.rows.item(i).type,
                            "description":results.rows.item(i).description != null ? results.rows.item(i).description : "",
                            "genre":results.rows.item(i).genre != null ? results.rows.item(i).genre : "",
                            "mode":results.rows.item(i).mode != null ? results.rows.item(i).mode : "",
                            "epoque":results.rows.item(i).epoque != null ? results.rows.item(i).epoque : "",
                            "couleur":results.rows.item(i).couleur != null ? results.rows.item(i).couleur : "",
                            "taille":results.rows.item(i).taille != null ? results.rows.item(i).taille : "",
                            "etat":results.rows.item(i).etat != null ? results.rows.item(i).etat : "",
                            "emplacement":results.rows.item(i).emplacement != null ? results.rows.item(i).emplacement : "",
                            "emprunteur":results.rows.item(i).emprunteur != null ? results.rows.item(i).emprunteur : "",
                            "date_emprunt": results.rows.item(i).date_emprunt != null ? results.rows.item(i).date_emprunt : "",
                            "date_retour": results.rows.item(i).date_retour != null ? results.rows.item(i).date_retour : "",
                            "commentaires": results.rows.item(i).commentaires != null ? results.rows.item(i).commentaires : ""
                             })
            console.log("Cache memoring : " + Math.round((i / results.rows.length)*100) + "%")
        }
        console.log("db size after update: " + listModel.count)
    })
}


function dbSet(rowid, costume)
{
    let db = dbGetHandle()
    console.log("Set in db the line  " + rowid + " type : " + costume.type)
    db.transaction(function (tx) {
        tx.executeSql(
                    'update costume set id=?, type=?, description=?, genre=?, mode=?, epoque=?, couleur=?, taille=?, etat=?, emplacement=?, emprunteur=?, date_emprunt=?, date_retour=?, commentaires=? where rowid = ?',
                    [rowid, costume.type, costume.description, costume.genre, costume.mode, costume.epoque, costume.couleur, costume.taille, "", "", "", "", "", "", id])
    })
}

function dbUpdate(costume)
{
    let db = dbGetHandle()
    console.log("Update in db the id  " + costume.id + " type : " + costume.type + " description : " + costume.description + " emprunteur : " + costume.emprunteur)
    db.transaction(function (tx) {
        tx.executeSql(
                    'update costume set id=?, type=?, description=?, genre=?, mode=?, epoque=?, couleur=?, taille=?, etat=?, emplacement=?, emprunteur=?, date_emprunt=?, date_retour=?, commentaires=? where rowid = ?',
                    [costume.id, costume.type, costume.description, costume.genre, costume.mode, costume.epoque, costume.couleur, costume.taille, costume.etat, costume.emplacement, costume.emprunteur, costume.date_emprunt, costume.date_retour, costume.commentaire, costume.id])
    })
}

function dbDeleteRow(Pid)
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        console.log("Delete in db the id  " + Pid)
        tx.executeSql('delete from costume where id = ?', [Pid])
    })
}

function getListOfCostumeOfAdherent(adherentName)
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
                'SELECT rowid,id,type, couleur, taille, date_emprunt, genre, etat FROM costume WHERE emprunteur is ? order by rowid desc', [adherentName])
            listCostumeEmpruntModel.clear()
        for (let i = 0; i < results.rows.length; i++) {
            listCostumeEmpruntModel.append({
                            "id": Math.round(results.rows.item(i).id),
                            "type":results.rows.item(i).type,
                            "couleur":results.rows.item(i).couleur != null ? results.rows.item(i).couleur : "",
                            "taille":results.rows.item(i).taille != null ? results.rows.item(i).taille : "",
                            "genre":results.rows.item(i).genre != null ? results.rows.item(i).genre : "",
                            })
            // console.log("Find in db: " + listModel.get(listModel.count-1).type)
        }
        console.log("number of borrowed costumes of " + adherentName + " : " + listCostumeEmpruntModel.count)
    })
}

function jsUpdate(adherents)
{
    listEmprunterModel.clear()
    for (let i = 0; i < adherents.length; i++) {
        listEmprunterModel.append({
                        "name": adherents[i]
                         })
        //console.log("Find in adherent list: " + listEmprunterModel.get(listEmprunterModel.count-1).name)
    }
    console.log("Adherent model size after update: " + listEmprunterModel.count)
}

function dbReadAllAdherents()
{
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql(
                'SELECT rowid, name FROM adherent order by rowid desc')
        listEmprunterModel.clear()
        console.log("Find in db: " + results.rows.length + " adherents")
        for (let i = 0; i < results.rows.length; i++) {
            listEmprunterModel.append({
                            "name": results.rows.item(i).name,
                             })
        }
        console.log("Adherent model size after update: " + listEmprunterModel.count)
    })
}
