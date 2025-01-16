import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/profile_page.dart';
import 'package:amc/services/mqtt_service.dart';

class MessagePage extends StatelessWidget {
  final String username;
  final String userId;
  final String deviceId;
  final String role;
  final MqttService mqttService;
  final TextEditingController messageController = TextEditingController();

  MessagePage({
    required this.username,
    required this.userId,
    required this.deviceId,
    required this.role,
    required this.mqttService,
  }) {
    if (deviceId.isEmpty) {
      print("Erreur : deviceId est vide.");
    }

    // S'abonner au sujet MQTT
    if (mqttService.isConnected()) {
      mqttService.subscribe('AMC/topic');
    } else {
      mqttService.connect().then((_) {
        mqttService.subscribe('AMC/topic');
      });
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour envoyer un message
  Future<void> _sendMessage(BuildContext context, String message) async {
    if (message.isEmpty) {
      _showSnackbar(context, "Le message ne peut pas être vide.");
      return;
    }

    try {
      //Enregistrer le message dans Firestore
      await _firestore.collection('history').add({
        'deviceId': deviceId,
        'timestamp': Timestamp.now(),
        'username': username,
        'message': message,
      });

      print("Message enregistré dans Firestore : $message");
    } catch (e) {
      print("Erreur lors de l'envoi du message dans Firestore : $e");
      _showSnackbar(
          context, "Erreur lors de l'envoi du message dans Firestore : $e");
      return;
    }

    try {
      // Étape 2 : Vérifier la connexion MQTT et envoyer le message
      if (!mqttService.isConnected()) {
        print("Connexion à MQTT...");
        await mqttService.connect();
        print("Connecté au broker MQTT.");
      }

      mqttService.publish('AMC/topic', message);
      print("Message envoyé via MQTT : $message");
      _showSnackbar(context, "Message envoyé avec succès !");
    } catch (e) {
      print("Erreur lors de l'envoi via MQTT : $e");
      _showSnackbar(context, "Erreur lors de l'envoi via MQTT : $e");
    }
  }

  // Fonction pour afficher une barre de notification
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
              // Ouvrir la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    username: username,
                    userId: userId,
                    role: role,
                    mqttService: mqttService,
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
                await _sendMessage(context, message);
                messageController.clear();
              },
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}
