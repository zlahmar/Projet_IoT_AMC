import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceSettingsPage extends StatelessWidget {
  final String deviceId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DeviceSettingsPage({required this.deviceId});

  final TextEditingController modeController = TextEditingController();
  final TextEditingController scrollSpeedController = TextEditingController();
  final TextEditingController sensitivityController = TextEditingController();

  Future<void> _saveSettings() async {
    try {
      await _firestore.collection('deviceParams').doc(deviceId).set({
        'mode': modeController.text,
        'scrollSpeed': int.tryParse(scrollSpeedController.text) ?? 0,
        'sensitivity': int.tryParse(sensitivityController.text) ?? 0,
      });
      print("Paramètres mis à jour.");
    } catch (e) {
      print("Erreur lors de la mise à jour des paramètres : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres de l'appareil")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: modeController,
              decoration: InputDecoration(labelText: "Mode"),
            ),
            TextField(
              controller: scrollSpeedController,
              decoration: InputDecoration(labelText: "Vitesse de défilement"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sensitivityController,
              decoration: InputDecoration(labelText: "Sensibilité"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
