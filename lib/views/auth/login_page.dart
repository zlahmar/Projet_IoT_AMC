// login_page.dart
import 'package:flutter/material.dart';
import '../home/message_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            TextField(
              controller: deviceIdController,
              decoration: InputDecoration(labelText: "ID de l'appareil"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action de connexion (validation du formulaire ou interaction Firebase)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MessagePage(username: usernameController.text)),
                );
              },
              child: Text("Se connecter"),
            ),
            TextButton(
              onPressed: () {
                // Code de scan du QR code pour remplir l'ID de l'appareil
                // (Utilisation d'un package de scan QR)
              },
              child: Text("Scanner le QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
