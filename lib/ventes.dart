import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Ventes extends StatefulWidget {
  Ventes({Key key}) : super(key: key);

  @override
  _Ventes createState() => _Ventes();
}

class _Ventes extends State<Ventes> {

  //Lire fichier csv et faire un tableau avec possibilité de supprimer ou modifier
  File fichierDonnees;

  Future<File> get _localFile async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    return File('${tempDir.path}/commande.csv');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localFile.then((value) => fichierDonnees = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}