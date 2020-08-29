import 'package:flutter/material.dart';
import 'package:mia_paiement/database/mysql.dart';

class Ventes extends StatefulWidget {
  Ventes({Key key}) : super(key: key);

  @override
  _Ventes createState() => _Ventes();
}

class _Ventes extends State<Ventes> {

  final dbHelper = MySQL.instance;

  void getAll() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}