import 'package:flutter/material.dart';
import 'register_page.dart'; // Page d'inscription
import 'forgot_password_page.dart'; // Page pour mot de passe oublié
import '../home/device_selection_page.dart'; // Page de sélection de l'appareil

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              controller: emailController,
              decoration: InputDecoration(labelText: "Adresse e-mail"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Mot de passe"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique de connexion, puis redirection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeviceSelectionPage()),
                );
              },
              child: Text("Se connecter"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pas de compte ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text("S'inscrire"),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: Text("Mot de passe oublié ?"),
            ),
          ],
        ),
      ),
    );
  }
}
