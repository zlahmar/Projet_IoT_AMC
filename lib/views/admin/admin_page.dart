//Cette page n'est plus necessaire, tout est gerer dans le profil

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/message_page.dart';
import 'history_page.dart';
import 'users_page.dart'; // Page à créer pour gérer les utilisateurs
import 'device_settings_page.dart'; // Page à créer pour les paramètres des appareils

class AdminPage extends StatelessWidget {
  final String username; // Nom de l'utilisateur
  final String role; // Rôle de l'utilisateur (superadmin ou admin)
  final String deviceId; // Identifiant de l'appareil
  final String userId; // Identifiant de l'utilisateur (userId ajouté ici)

  AdminPage({
    required this.username,
    required this.role,
    required this.deviceId,
    required this.userId, // Ajout de userId dans le constructeur
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            role == 'superadmin' ? "Super Administrateur" : "Administrateur"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Ajouter ici la logique de déconnexion
              print("Déconnexion");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fonctionnalités d'administration pour $deviceId",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureButton(
                    context,
                    label: "Envoyer un message",
                    icon: Icons.message,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            username: username,
                            role: role,
                            deviceId: deviceId,
                            userId: userId, // Passer userId ici
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: "Paramètres de l'appareil",
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceSettingsPage(
                            deviceId: deviceId,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    label: "Historique",
                    icon: Icons.history,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(deviceId: deviceId),
                        ),
                      );
                    },
                  ),
                  if (role ==
                      'superadmin') // Accessible uniquement pour les superadmins
                    _buildFeatureButton(
                      context,
                      label: "Gérer les utilisateurs",
                      icon: Icons.supervised_user_circle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UsersPage(), // Page des utilisateurs
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
