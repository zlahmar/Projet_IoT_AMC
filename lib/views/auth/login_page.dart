// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'register_page.dart';
// import 'forgot_password_page.dart';
// import '../home/device_selection_page.dart';

// class LoginPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Connexion"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //affichage du logo
//             Center(
//               child: Image.asset(
//                 'images/logo.png',
//                 height: 100,
//               ),
//             ),
//             SizedBox(height: 30),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: "Adresse e-mail",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: "Mot de passe",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (emailController.text.isEmpty ||
//                     passwordController.text.isEmpty) {
//                   // Si un champ est vide, affichez un message d'erreur
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text("Erreur"),
//                       content: Text(
//                           "Veuillez remplir tous les champs pour continuer."),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text("OK"),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   try {
//                     // Authentification Firebase
//                     UserCredential userCredential = await FirebaseAuth.instance
//                         .signInWithEmailAndPassword(
//                             email: emailController.text,
//                             password: passwordController.text);

//                     // Connexion réussie
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DeviceSelectionPage(
//                           username: userCredential.user?.email ?? '',
//                           userId: userCredential.user?.uid ?? '',
//                           mqttService: ,
//                         ),
//                       ),
//                     );
//                   } catch (e) {
//                     // En cas d'erreur
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Erreur"),
//                         content:
//                             Text("Échec de la connexion : ${e.toString()}"),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text("OK"),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: Text("Se connecter"),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Pas de compte ?"),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegisterPage()),
//                     );
//                   },
//                   child: Text("S'inscrire"),
//                 ),
//               ],
//             ),
//             //SizedBox(height: 10),
//             Align(
//               alignment: Alignment.center,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ForgotPasswordPage(),
//                     ),
//                   );
//                 },
//                 child: Text("Mot de passe oublié ?"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../home/device_selection_page.dart';
import 'package:amc/services/mqtt_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //affichage du logo
            Center(
              child: Image.asset(
                'images/logo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Adresse e-mail",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  // Si un champ est vide, affichez un message d'erreur
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Erreur"),
                      content: Text(
                          "Veuillez remplir tous les champs pour continuer."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  try {
                    // Authentification Firebase
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    // Connexion MQTT
                    const broker = 'broker.emqx.io';
                    const clientId =
                        'flutter_client'; // ID unique du client MQTT
                    const port = 1883;
                    final mqttService = MqttService(
                      broker: broker,
                      port: port,
                      clientId: clientId,
                    );

                    // Connexion au broker MQTT
                    await mqttService.connect();

                    // Connexion réussie, navigation vers DeviceSelectionPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceSelectionPage(
                          username: userCredential.user?.email ?? '',
                          userId: userCredential.user?.uid ?? '',
                          mqttService: mqttService, // Passer mqttService ici
                        ),
                      ),
                    );
                  } catch (e) {
                    // En cas d'erreur
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Erreur"),
                        content:
                            Text("Échec de la connexion : ${e.toString()}"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text("Se connecter"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pas de compte ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text("S'inscrire"),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text("Mot de passe oublié ?"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
