import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/profile_page.dart';
import '../admin/history_page.dart'; // Page pour afficher l'historique (à créer)

class MessagePage extends StatelessWidget {
  final String username; // Nom de l'utilisateur
  final String role; // Rôle de l'utilisateur (admin, superadmin, user)
  final String deviceId; // Identifiant de l'appareil
  final TextEditingController messageController = TextEditingController();

  MessagePage({
    required this.username,
    required this.role,
    required this.deviceId,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      // Ajouter le message à l'historique
      await _firestore.collection('history').add({
        'deviceId': deviceId,
        'timestamp': Timestamp.now(),
        'username': username,
        'message': message,
      });

      // Logique pour envoyer le message au périphérique (par ex., via MQTT ou une autre méthode)
      print("Message envoyé : $message");
    } catch (e) {
      print("Erreur lors de l'envoi du message : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Envoyer un Message"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Ouvre la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(username: username)),
              );
            },
          ),
          if (role == 'admin' ||
              role == 'superadmin') // Admins/superadmins uniquement
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                // Ouvre la page d'historique
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryPage(deviceId: deviceId)),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: "Tapez votre message",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String message = messageController.text.trim();
                await _sendMessage(message);
                messageController.clear();
              },
              child: Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}
