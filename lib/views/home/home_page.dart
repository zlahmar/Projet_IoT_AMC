import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/message_page.dart';
import '../admin/admin_page.dart';

class HomePage extends StatelessWidget {
  final String username; // Nom d'utilisateur actuel
  final String deviceId; // Identifiant de l'appareil

  HomePage({required this.username, required this.deviceId});

  Future<Map<String, String>> _fetchUserDetails(String username) async {
    try {
      // Accède à Firestore pour récupérer le rôle et l'ID de l'utilisateur
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userDoc.docs.isNotEmpty) {
        // Récupère les informations du premier utilisateur trouvé
        final userData = userDoc.docs.first.data();
        return {
          'role': userData['role'] ?? 'user',  // Par défaut, rôle "user"
          'userId': userDoc.docs.first.id      // Récupère l'ID de l'utilisateur
        };
      }
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur : $e");
    }
    return {'role': 'user', 'userId': ''}; // Retourne un rôle par défaut si une erreur survient
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _fetchUserDetails(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Affiche un indicateur de chargement pendant la récupération des données
          return Scaffold(
            appBar: AppBar(title: Text("Accueil")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!['userId'] == '') {
          // Gère les erreurs éventuelles
          return Scaffold(
            appBar: AppBar(title: Text("Erreur")),
            body: Center(
              child: Text(
                "Impossible de charger les données utilisateur.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        // Récupère le rôle et l'ID de l'utilisateur
        final role = snapshot.data!['role']!;
        final userId = snapshot.data!['userId']!;

        // Redirige vers les pages correspondantes
        return Scaffold(
          appBar: AppBar(title: Text("Accueil")),
          body: role == 'superadmin' || role == 'admin'
              ? AdminPage(
                  username: username,
                  role: role,
                  deviceId: deviceId,
                  userId: userId,  // Passer `userId` à la page Admin
                )
              : MessagePage(
                  username: username,
                  deviceId: deviceId,
                  role: role,
                  userId: userId,  // Passer `userId` à la page Message
                ),
        );
      },
    );
  }
}

