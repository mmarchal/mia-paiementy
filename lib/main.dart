import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mia_paiement/myapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
}
