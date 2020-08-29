import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mia_paiement/database/modele/vente.dart';
import 'package:mia_paiement/database/mysql.dart';
import 'package:mia_paiement/menu.dart';
import 'package:mia_paiement/validation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Paiement extends StatefulWidget {
  Paiement({Key key}) : super(key: key);

  @override
  _Paiement createState() => _Paiement();
}

class _Paiement extends State<Paiement> {

  String _scanBarcode = 'Unknown';
  int _groupValue = -1;

  List<Produit> produitsList = new List();

  double prix = 0.0;

  TextEditingController textEditingController = new TextEditingController();
  final dbHelper = MySQL.instance;

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    this.analyseQrCode(_scanBarcode);
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
    );
  }

  @override
  void initState() {
    super.initState();
    this.scanBarcodeNormal();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Icon(Icons.shopping_basket, size: 64.0, color: Colors.grey,),),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Panier MIA BIJOUX", style: GoogleFonts.openSansCondensed(fontWeight: FontWeight.bold, color: Colors.grey), textScaleFactor: 1.7,),
                ),
                Center(child: Icon(Icons.shopping_basket, size: 64.0, color: Colors.grey,),),
              ],
            ),
            new Flexible(child: GridView.builder(
                itemCount: produitsList.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  Produit p = produitsList[index];
                  return Card(
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(p.nomProduit, textScaleFactor: 1.2,),
                        Text(p.prixProduit, textScaleFactor: 1.2,),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            //color: Colors.red,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    bottomRight: Radius.circular(25.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete, color: Colors.white,),
                                Text("Supprimer", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              produitsList.removeAt(index);
                              setState(() {
                                prix = prix - double.parse(p.prixProduit.replaceAll("€", "").replaceAll(",", "."));
                              });
                            });
                          },
                        )
                      ],
                    ),
                  );
                })),
            Text("Total : " + prix.toString() + " € "),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                      return new Menu();
                    }));
                  },
                  child: Text("Retour au menu"),
                ),
                RaisedButton(
                  onPressed: () {
                    this.scanBarcodeNormal();
                  },
                  child: Text("Scanner à nouveau"),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      prix = 0.0;
                      produitsList.clear();
                    });
                  },
                  child: Text("Vider le panier"),
                ),
                RaisedButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          int selectedRadio = 0;
                          return AlertDialog(
                            content: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Choix du paiement du client : ", textAlign: TextAlign.center,),
                                    SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _myRadioButton(
                                          title: "Checkbox 0",
                                          value: 0,
                                          onChanged: (newValue) => setState(() => _groupValue = newValue),
                                        ),
                                        new Text(
                                          'Liquide',
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                        _myRadioButton(
                                          title: "Checkbox 1",
                                          value: 1,
                                          onChanged: (newValue) => setState(() => _groupValue = newValue),
                                        ),
                                        new Text(
                                          'Chèque',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Text("Nom du client : ", textAlign: TextAlign.center,),
                                    SizedBox(height: 15,),
                                    Flexible(
                                        child: TextField(
                                          controller: textEditingController,
                                          decoration: InputDecoration(
                                              hintText: 'Exemple : Dupont'
                                          ),
                                        )
                                    ),
                                    SizedBox(height: 15,),
                                    RaisedButton(
                                      child: Text("Valider le paiement"),
                                      onPressed: () {
                                        String produitsAchetes = "";
                                        Vente v = new Vente();
                                        for(int i = 0; i<produitsList.length; i++) {
                                          produitsAchetes = produitsAchetes + produitsList[i].nomProduit + " / ";
                                        }
                                        v.id=null;
                                        v.nom_produit = produitsAchetes;
                                        v.prix_produit = prix.toString();
                                        v.type_paiement = (_groupValue==1) ? "Chèque" : "Liquide";
                                        v.acheteur = textEditingController.text;
                                        print(v.toMap());
                                        dbHelper.insert(v.toMap()).then((value) => print(value));
                                      },
                                    )
                                  ],
                                );
                              },
                            ),
                          );
                        }
                    );
                  },
                  child: Text("Valider le panier"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void analyseQrCode(String scanBarcode) {

    Produit produit = new Produit();

    String resultat = scanBarcode.replaceAll("Ajouter aux favoris", ";").replaceAll("Note", " Note").replaceAll("Epuisé", ";").replaceAll(" ", ";");
    List<String> liste = resultat.split(";");

    for( int i=0; i<liste.length; i++ ) {

      String element = liste[i];

      if(element=="Boucles" || element=="Bague" || element=="Bracelet" || element=="Collier") {
        produit.nomProduit = element + " " + liste[i+1];
      } else if (element.contains("€")) {
        produit.prixProduit = element;
        element = element.replaceAll("€", "").replaceAll(",", ".");
        setState(() {
          prix += double.parse(element);
        });
      }

    }

    produitsList.add(produit);

  }

}

class Produit {

  String nomProduit;
  String prixProduit;

  @override
  String toString() {
    return 'Produit{nomProduit: $nomProduit, prixProduit: $prixProduit}';
  }


}