import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/profile_page.dart';

class MessagePage extends StatelessWidget {
  final String username; // Nom de l'utilisateur
  final String userId; // ID de l'utilisateur
  final String deviceId; // Identifiant de l'appareil
  final String role; // Rôle de l'utilisateur (admin, superadmin, etc.)
  final TextEditingController messageController = TextEditingController();

  MessagePage({
    required this.username,
    required this.userId,
    required this.deviceId,
    required this.role, // Ajout de role dans le constructeur
  }) {
    if (deviceId.isEmpty) {
      print("Erreur : deviceId est vide.");
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      await _firestore.collection('history').add({
        'deviceId': deviceId,
        'timestamp': Timestamp.now(),
        'username': username,
        'message': message,
      });

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
                  builder: (context) => ProfilePage(
                    username: username,
                    userId: userId,
                    role: role,
                  ),
                ),
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
