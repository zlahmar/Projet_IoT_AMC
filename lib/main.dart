import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import './views/home/welcome_page.dart'; // Page d'accueil après l'initialisation
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afficheur Multi-Contenu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage(), // Page d'accueil après l'initialisation
    );
  }
}
