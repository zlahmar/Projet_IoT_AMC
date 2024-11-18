// profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController usernameController;

  ProfilePage({required String username})
      : usernameController = TextEditingController(text: username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Enregistrer les modifications du username
                print("Nouveau nom d'utilisateur : ${usernameController.text}");
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
