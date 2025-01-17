import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';

class DeviceSettingsPage extends StatefulWidget {
  final String deviceId;
  final MqttClient mqttClient; // Ajout du client MQTT

  DeviceSettingsPage({required this.deviceId, required this.mqttClient});

  @override
  _DeviceSettingsPageState createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedMode = "message"; // Mode par défaut
  final TextEditingController scrollSpeedController = TextEditingController();
  final TextEditingController sensitivityController = TextEditingController();

  // Fonction pour sauvegarder les paramètres Firestore (facultatif)
  Future<void> _saveSettingsToFirestore() async {
    try {
      await _firestore.collection('deviceParams').doc(widget.deviceId).set({
        'mode': selectedMode,
        'scrollSpeed': int.tryParse(scrollSpeedController.text) ?? 0,
        'sensitivity': int.tryParse(sensitivityController.text) ?? 0,
      });
      print("Paramètres sauvegardés dans Firestore.");
    } catch (e) {
      print("Erreur lors de la sauvegarde : $e");
    }
  }

  // Fonction pour envoyer le mode via MQTT
  void _sendModeToMQTT() {
    if (widget.mqttClient.connectionStatus?.state ==
        MqttConnectionState.connected) {
      final modeMessage = MqttClientPayloadBuilder();
      modeMessage.addString(selectedMode);
      widget.mqttClient.publishMessage(
        "AMC/topic/mode",
        MqttQos.atMostOnce,
        modeMessage.payload!,
      );
      print("Mode envoyé via MQTT : $selectedMode");
    } else {
      print("Client MQTT non connecté !");
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
            // Ajout du switch ou d'un menu déroulant pour le mode
            DropdownButton<String>(
              value: selectedMode,
              onChanged: (String? newMode) {
                if (newMode != null) {
                  setState(() {
                    selectedMode = newMode;
                  });
                  _sendModeToMQTT(); // Envoyer le mode immédiatement
                }
              },
              items: [
                DropdownMenuItem(
                  value: "message",
                  child: Text("Mode Message"),
                ),
                DropdownMenuItem(
                  value: "affichage",
                  child: Text("Mode Affichage"),
                ),
              ],
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
              onPressed: () {
                _saveSettingsToFirestore();
              },
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
