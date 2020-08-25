import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Paiement extends StatefulWidget {
  Paiement({Key key}) : super(key: key);

  @override
  _Paiement createState() => _Paiement();
}

class _Paiement extends State<Paiement> {

  String _scanBarcode = 'Unknown';

  // Platform messages are asynchronous, so we initialize in an async method.
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.scanBarcodeNormal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scan result : $_scanBarcode\n',
                style: TextStyle(fontSize: 20)),
            RaisedButton(
                onPressed: () {
                  this.scanBarcodeNormal();
                },
              child: Text("Scanner à nouveau"),
            )
          ],
        ),
      ),
    );
  }

}