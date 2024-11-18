// message_page.dart
import 'package:flutter/material.dart';
import '../auth/profile_page.dart';

class MessagePage extends StatelessWidget {
  final String username;
  final TextEditingController messageController = TextEditingController();

  MessagePage({required this.username});

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
                MaterialPageRoute(builder: (context) => ProfilePage(username: username)),
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
              onPressed: () {
                // Envoi du message (par exemple, via Firebase ou MQTT)
                print("Message envoyé : ${messageController.text}");
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
