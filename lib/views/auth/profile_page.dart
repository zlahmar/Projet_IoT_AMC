import 'package:amc/services/mqtt_service.dart';
import 'package:amc/views/admin/device_settings_page.dart';
import 'package:amc/views/admin/history_page.dart';
import 'package:amc/views/admin/users_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/message_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String userId;
  final String role; // Rôle de l'utilisateur (admin, superadmin, user)
  final MqttService mqttService;

  ProfilePage(
      {required this.username,
      required this.userId,
      required this.role,
      required this.mqttService});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController usernameController;
  List<String> userDevices = [];
  late String currentRole; // Variable pour gérer le rôle localement

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    currentRole = widget.role; // Initialisation avec le rôle actuel
    _loadUserDevices();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          currentRole = userDoc.get('role'); // Mettez à jour le rôle localement
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération du rôle : $e");
    }
  }

  // Fonction pour recharger les données utilisateur
  Future<void> _refreshUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          currentRole = userDoc.get('role'); // Mise à jour du rôle
          userDevices = List<String>.from(userDoc.get('deviceIds') ?? []);
        });
        print("Rôle mis à jour : $currentRole");
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Données utilisateur rechargées avec succès !"),
      ));
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors du rechargement des données."),
      ));
    }
  }

  // Fonction pour mettre à jour le nom d'utilisateur dans Firestore
  Future<void> _updateUsername() async {
    try {
      String newUsername = usernameController.text.trim();
      if (newUsername.isEmpty) {
        print("Le nom d'utilisateur ne peut pas être vide.");
        return;
      }

      // Mise à jour du nom d'utilisateur dans Firestore
      await _firestore.collection('users').doc(widget.userId).update({
        'username': newUsername,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Nom d'utilisateur mis à jour avec succès !"),
      ));
      Navigator.pop(context);
    } catch (e) {
      print("Erreur lors de la mise à jour du nom d'utilisateur : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de la mise à jour du nom d'utilisateur."),
      ));
    }
  }

  // Fonction pour charger les appareils associés à l'utilisateur
  Future<void> _loadUserDevices() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          userDevices = List<String>.from(userDoc.get('deviceIds') ?? []);
        });
      }
    } catch (e) {
      print("Erreur lors du chargement des appareils : $e");
    }
  }

  // Méthode pour vérifier si le rôle de l'utilisateur est admin ou superadmin
  // bool isAdminOrSuperAdmin() {
  //   return widget.role == 'admin' || widget.role == 'superadmin';
  // }
  // bool isAdminOrSuperAdmin() {
  //   return true; // Force le rôle pour tester les boutons
  // }
  bool isAdminOrSuperAdmin() {
    print("Vérification du rôle dans isAdminOrSuperAdmin : $currentRole");
    return currentRole == 'admin' || currentRole == 'superadmin';
  }

  // Fonction pour gérer la déconnexion
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Ajout du bouton de déconnexion
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage du rôle de l'utilisateur au centre
            Center(
              child: Chip(
                label: Text(
                  'Rôle: $currentRole', // Affiche le rôle actuel
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blueGrey, // Couleur de fond du Chip
              ),
            ),
            // Champ de texte pour modifier le nom d'utilisateur
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUsername,
              child: Text("Enregistrer"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshUserData,
              child: Text("Recharger les données"),
            ),

            SizedBox(height: 30),
            Text(
              "Vos appareils :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: userDevices.isEmpty
                  ? Center(child: Text("Aucun appareil trouvé."))
                  : ListView.builder(
                      itemCount: userDevices.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.devices, color: Colors.blue),
                            title: Text(
                              userDevices[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagePage(
                                    username: widget.username,
                                    role: widget.role,
                                    deviceId: userDevices[index],
                                    userId: widget.userId,
                                    mqttService: widget.mqttService,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 30),
            Text(
              "Fonctionnalités d'administration :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureButton(
                    label: "Envoyer un message",
                    icon: Icons.message,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            username: widget.username,
                            role: widget.role,
                            deviceId:
                                userDevices.isNotEmpty ? userDevices[0] : '',
                            userId: widget.userId,
                            mqttService: widget.mqttService,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    label: "Historique",
                    icon: Icons.history,
                    onTap: () {
                      if (userDevices.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistoryPage(deviceId: userDevices[0]),
                          ),
                        );
                      } else {
                        // Afficher un message d'erreur si aucun deviceId n'est disponible
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Aucun appareil disponible pour l'historique."),
                          ),
                        );
                      }
                    },
                  ),
                  _buildFeatureButton(
                    label: "Paramètres de l'appareil",
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeviceSettingsPage(deviceId: ''),
                        ),
                      );
                    },
                  ),
                  if (isAdminOrSuperAdmin())
                    _buildFeatureButton(
                      label: "Gérer les utilisateurs",
                      icon: Icons.supervised_user_circle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersPage(),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFeatureButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    print('Bouton : $label, Role : ${widget.role}');
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: isAdminOrSuperAdmin() ? onTap : null,
      ),
    );
  }
}
