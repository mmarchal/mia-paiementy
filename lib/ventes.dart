import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mia_paiement/menu.dart';
import 'package:mia_paiement/modele/DatabaseHelper.dart';
import 'package:mia_paiement/modele/vente.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mailer/mailer.dart';

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

  final dbHelper = DatabaseHelper.instance;

  final f = new DateFormat('dd-MM-yyyy hh:mm');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.queryAllRows().then((value) {
      value.forEach((element) {
        setState(() {
          ventesProduits.add(element);
        });
      });
    });
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
    if( ventesProduits !=null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Historique des ventes"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                  return new Menu();
                }));
              }
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () {
                recupDatasEtEcritureFichier();
              },
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
                        dbHelper.delete(ve.id);
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                          return new Ventes();
                        }));
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

  Future<void> recupDatasEtEcritureFichier() async {
    String datas = "";
    String filename = "donneesApp.csv";

    dbHelper.queryAllRows().then((value) {
      value.forEach((element) {
        setState(() {
          datas+=("${element.toString()}\n");
        });
      });
    }).whenComplete(() async {
      String dir = await getApplicationDocumentsDirectory().then((value) => value.path);
      print(dir);
      File file = new File('$dir/$filename');
      file.writeAsString(datas);
      this._sendEmail(file);
      return file;
    });

  }

  void _sendEmail(File x) async {
    String username = 'maximemarchal24@gmail.com';
    String password = 'emlhxnqqwkcswlhp';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('maximemarchal24@gmail.com')
      ..attachments.add(FileAttachment(x))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      Fluttertoast.showToast(
          msg: "Message envoyé !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on MailerException catch (e) {
      for (var p in e.problems) {
        Fluttertoast.showToast(
            msg: "Message non envoyé : ${p.code}: ${p.msg}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

}