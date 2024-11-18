import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mot de passe oublié")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Entrez votre adresse e-mail pour réinitialiser votre mot de passe",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Adresse e-mail"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique de réinitialisation du mot de passe
                Navigator.pop(context); // Retourne à la page de connexion
              },
              child: Text("Réinitialiser le mot de passe"),
            ),
          ],
        ),
      ),
    );
  }
}
