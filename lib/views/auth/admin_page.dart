import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final String deviceId;

  AdminPage({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Administrateur")),
      body: Center(
        child: Text(
          "Fonctionnalités d'administration pour $deviceId",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
