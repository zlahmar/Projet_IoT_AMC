import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/message_page.dart';
import '../admin/admin_page.dart';

class HomePage extends StatelessWidget {
  final String username; // Nom d'utilisateur actuel
  final String deviceId; // Identifiant de l'appareil

  HomePage({required this.username, required this.deviceId});

  Future<String> _fetchUserRole(String username) async {
    try {
      // Accède à Firestore pour récupérer le rôle de l'utilisateur
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data()['role'] ??
            'user'; // Default role: user
      }
    } catch (e) {
      print("Erreur lors de la récupération du rôle : $e");
    }
    return 'user'; // Par défaut, on considère que c'est un utilisateur normal
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchUserRole(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Affiche un indicateur de chargement pendant la récupération des données
          return Scaffold(
            appBar: AppBar(title: Text("Accueil")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
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

        // Récupère le rôle de l'utilisateur
        final role = snapshot.data!;

        // Redirige vers les pages correspondantes
        return Scaffold(
          appBar: AppBar(title: Text("Accueil")),
          body: role == 'superadmin' || role == 'admin'
              ? AdminPage(
                  username: username,
                  role: role,
                  deviceId: deviceId,
                )
              : MessagePage(
                  username: username,
                  deviceId: deviceId,
                  role: role,
                ),
        );
      },
    );
  }
}
