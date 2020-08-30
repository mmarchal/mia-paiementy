import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mia_paiement/paiement.dart';
import 'package:mia_paiement/stock.dart';
import 'package:mia_paiement/ventes.dart';
import 'dart:io' as io;

class Menu extends StatefulWidget {
  Menu({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {



  /*void creationFichierHistorique() {
    File fichierHisto = new File("fichier/histo.xslx");

    fichierHisto.exists().then((value) {

      if(value) {
        fichier = fichierHisto;
      } else {
        fichier = fichierHisto.create().then((value) => p);
      }

    }).catchError((error) {
      print(error);
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.width/3.5,
                  ),
                  SizedBox(width: 30,),
                  FlutterLogo(size: MediaQuery.of(context).size.width/4.5,)
                ],
              ),
              new SizedBox(
                height: 10.0,
                child: new Center(
                  child: new Container(
                    margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 5.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 3),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          "assets/paiement.jpg",
                          width: MediaQuery.of(context).size.width/2,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3.5,
                        child: Text("Effectuer un paiement", textAlign: TextAlign.center, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold), textScaleFactor: 1.2,)
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                    return new Paiement();
                  }));
                },
              ),
              /*SizedBox(height: 20,),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green.shade400,
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 3),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: Text("Consulter le stock d'un produit", textAlign: TextAlign.center, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          "assets/stock.jpg",
                          width: MediaQuery.of(context).size.width/2,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                    return new Stock();
                  }));
                },
              ),*/
              SizedBox(height: 20,),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 3),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          "assets/ventes.png",
                          width: MediaQuery.of(context).size.width/2,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3.5,
                        child: Text("Consulter les ventes", textAlign: TextAlign.center, style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                    return new Ventes();
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}