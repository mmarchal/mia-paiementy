import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mia_paiement/menu.dart';
import 'package:mia_paiement/modele/vente.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Ventes extends StatefulWidget {
  Ventes({Key key}) : super(key: key);

  @override
  _Ventes createState() => _Ventes();
}

class _Ventes extends State<Ventes> {

  //Lire fichier csv et faire un tableau avec possibilité de supprimer ou modifier
  File fichierDonnees;
  String donnees;

  List<Vente> ventesProduits = new List();

  bool info;

  final f = new DateFormat('dd-MM-yyyy hh:mm');

  Future<File> get _localFile async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    return File('${tempDir.path}/commande.csv');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = decoupageFichier(fichierDonnees);
  }

  bool decoupageFichier(File fichierDonnees) {
    bool test;
    _localFile.then((value) {
      fichierDonnees = value;
      try {
        donnees = fichierDonnees.readAsStringSync();
        setState(() {
          test = true;
        });
      } catch (e) {
        print(e);
        setState(() {
          test = false;
        });
      }
      return test;
    });
  }

  void traitement() {

    List<String> listeProduits = donnees.split('\n');
    for( int i=0; i<listeProduits.length; i++ ) {

      List<String> decoupe = listeProduits[i].split(';');

      if(decoupe.length!=1) {
        Vente vente = new Vente();
        vente.date_vente = decoupe[0];
        vente.nom_produit = decoupe[1];
        vente.prix_produit = decoupe[2];
        vente.type_paiement = decoupe[3];
        vente.acheteur = decoupe[4];

        ventesProduits.add(vente);
      }

    }
    // Let's create a DataTable and show the employee list in it.
  }

  Widget texteFonce(String text, double xFactor) {
    return Text(text, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold), textScaleFactor: xFactor,);
  }

  Widget texteFonceColore(String text, Color couleur, double xFactor) {
    return Text(text, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold, color: couleur), textScaleFactor: xFactor,);
  }

  Widget texteColore(String text, Color couleur, double xFactor) {
    return Text(text, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold, color: couleur), textScaleFactor: xFactor,);
  }

  @override
  Widget build(BuildContext context) {
    if( info != null || info==true || donnees !=null) {
      traitement();
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Historique des ventes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () { Scaffold.of(context).openDrawer(); },
            ),
          ],
        ),
        body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: texteFonceColore('Supprimer', Colors.red, 1.5),
              ),
              DataColumn(
                label: texteFonce('Date de la vente', 1.5),
              ),
              DataColumn(
                label: texteFonce('Nom des produits', 1.5),
              ),
              DataColumn(
                label: texteFonce('Prix de la commande', 1.5),
              ),
              DataColumn(
                label: texteFonce('Type de paiement', 1.5),
              ),
              DataColumn(
                label: texteFonce('Acheteur', 1.5),
              )
            ],
            rows: ventesProduits
                .map(
                  (ve) => DataRow(cells: [
                    DataCell(
                      Icon(Icons.delete, color: Colors.red,),
                      onTap: () {
                        print(ve.toString());
                      },
                    ),
                DataCell(
                  Text(ve.date_vente),
                ),
                DataCell(
                  Text(
                    ve.nom_produit, style: TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    '${ve.prix_produit} €',
                  ),
                ),
                DataCell(
                  Text(
                    ve.type_paiement,
                  ),
                ),
                DataCell(
                  Text(
                    ve.acheteur,
                  ),
                )
              ]),
            ).toList(),
          ),
        ),
      ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Historique des ventes"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.error, color: Colors.red, size: 100,),
              SizedBox(height: 20,),
              Text("Erreur de lecture : pas de fichier !", style: GoogleFonts.openSansCondensed(color: Colors.red), textAlign: TextAlign.center, textScaleFactor: 2.0,),
              SizedBox(height: 20,),
              Container(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      onPressed: (){ Navigator.pop(context); },
                      textColor: Colors.white,
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color:Colors.white,
                                  size: 30,
                                ),
                              ),
                              Container(
                                color: Colors.red,
                                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                                child: Text('Retour au menu',
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ))))
            ],
          ),
        ),
      );
    }
  }

}