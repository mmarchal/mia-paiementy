import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mia_paiement/modele/vente.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "Mia-Paiement.db";
  static final _databaseVersion = 1;

  static final table = 'vente';

  static final columnId = 'id';
  static final columnDate = 'date_vente';
  static final columnNom = 'nom_produit';
  static final columnPrix = 'prix_produit';
  static final columnType = 'type_paiement';
  static final columnAcheteur = 'acheteur';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnNom TEXT NOT NULL,
            $columnPrix TEXT NOT NULL,
            $columnType TEXT NOT NULL,
            $columnAcheteur TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Vente>> queryAllRows() async {
    Database db = await instance.database;
    List<Map> list = await db.query(table);
    List<Vente> ventes = new List();
    for (int i = 0; i < list.length; i++) {
      Vente v = new Vente(id: list[i]["id"],date_vente: list[i]["date_vente"], nom_produit: list[i]["nom_produit"], prix_produit: list[i]["prix_produit"], type_paiement: list[i]["type_paiement"], acheteur: list[i]["acheteur"]);
      ventes.add(v);
    }
    return ventes;
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]).then((value) {
      if(value==1) {
        Fluttertoast.showToast(
            msg: "Commande supprimé des données",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        Fluttertoast.showToast(
            msg: "Erreur dans la suppression. Contacter l'admin",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  Future<List<Vente>> getVentes() async {
    var dbClient = await _database;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Ventes');
    List<Vente> ventes = new List();
    for (int i = 0; i < list.length; i++) {
      Vente v = new Vente(date_vente: list[i]["date_vente"], nom_produit: list[i]["nom_produit"], prix_produit: list[i]["prix_produit"], type_paiement: list[i]["type_paiement"], acheteur: list[i]["acheteur"]);
      ventes.add(v);
    }
    print(ventes.length);
    return ventes;
  }
}