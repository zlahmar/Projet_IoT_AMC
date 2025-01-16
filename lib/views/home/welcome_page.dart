// welcome_page.dart
import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Redirection vers la page de connexion après 3 secondes
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affiche le logo
            Image.asset('images/logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            Text(
              "Bienvenue",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:amc/services/mqtt_service.dart';

// class WelcomePage extends StatelessWidget {
//   final MqttService mqttService;

//   WelcomePage({required this.mqttService});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter MQTT Example")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             const topic = "AMC/topic"; // Sujet MQTT
//             const message = "Hello ESP32 from Flutter!";
//             mqttService.publish(topic, message); // Publier le message
//             print("Message envoyé : $message");
//           },
//           child: Text("Envoyer un message à ESP32"),
//         ),
//       ),
//     );
//   }
// }
