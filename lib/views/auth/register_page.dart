import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Adresse e-mail"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Mot de passe"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: "Confirmer le mot de passe"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique d'inscription
                Navigator.pop(
                    context); // Retourne à la page de connexion après inscription
              },
              child: Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
