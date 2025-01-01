import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/theme.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Instance de Firestore pour l'ajout de l'utilisateur à la collection 'users'
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addUserToFirestore(User user) async {
    try {
      // Vérifier si le document de l'utilisateur existe déjà
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Si le document n'existe pas, créer un nouveau document
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email, // Ajouter l'email
          'deviceIds': [], // Initialiser un tableau vide pour les appareils
          'createdAt':
              FieldValue.serverTimestamp(), // Ajouter la date de création
          'role': 'user', // Attribuer le rôle 'user' par défaut
        });

        print("Utilisateur ajouté à Firestore avec l'ID : ${user.uid}");
      } else {
        print("Utilisateur déjà existant.");
      }
    } catch (e) {
      print("Erreur lors de l'ajout de l'utilisateur : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un compte"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            // Titre
            Text(
              "Inscription",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Champ d'email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Adresse e-mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Champ de mot de passe
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Champ de confirmation de mot de passe
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirmer le mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Bouton d'inscription
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  // Les mots de passe ne correspondent pas
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Erreur",
                          style: TextStyle(color: AppColors.darkBlue)),
                      content: Text("Les mots de passe ne correspondent pas."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  try {
                    // Enregistrement avec Firebase Auth
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Ajouter l'utilisateur dans Firestore
                    await _addUserToFirestore(userCredential.user!);

                    // Retour à la page de connexion après inscription
                    Navigator.pop(context);
                  } catch (e) {
                    // En cas d'erreur
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Erreur",
                            style: TextStyle(color: AppColors.darkBlue)),
                        content:
                            Text("Échec de l'inscription : ${e.toString()}"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: Text("S'inscrire", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
