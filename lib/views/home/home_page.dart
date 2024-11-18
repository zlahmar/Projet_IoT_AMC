import 'package:flutter/material.dart';
import '../home/message_page.dart';
import '../auth/admin_page.dart';

class HomePage extends StatelessWidget {
  final String deviceId;

  HomePage({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final bool isSuperAdmin = true; // Détermine le rôle de l'utilisateur

    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: isSuperAdmin
          ? AdminPage(deviceId: deviceId)
          : MessagePage(username: "Utilisateur Normal"),
    );
  }
}
