import 'package:flutter/material.dart';
import 'package:mia_paiement/paiement.dart';

class Menu extends StatefulWidget {
  Menu({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "assets/paiement.jpg",
                  ),
                  Text("Effectuer un paiement")
                ],
              ),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
                  return new Paiement();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}