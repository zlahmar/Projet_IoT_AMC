import 'package:flutter/material.dart';
import './views/home/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afficheur Multi-Contenu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage(), // Démarre sur la page de bienvenue
    );
  }
}
