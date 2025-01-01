import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/message_page.dart';
import '/theme.dart';

class DeviceSelectionPage extends StatefulWidget {
  final String username; // Username de l'utilisateur
  final String userId; // UID de l'utilisateur Firebase

  DeviceSelectionPage({required this.username, required this.userId});

  @override
  _DeviceSelectionPageState createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> userDevices = [];

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      print("Erreur: userId est vide !");
      return;
    }
    _loadUserDevices(); // Charger les appareils associés à l'utilisateur
  }

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

  Future<void> _addDevice(String deviceId) async {
    if (deviceId.isEmpty) {
      print("Erreur : deviceId est vide.");
      return;
    }

    try {
      // Vérifiez si l'appareil existe déjà
      DocumentSnapshot existingDevice =
          await _firestore.collection('devices').doc(deviceId).get();

      if (existingDevice.exists) {
        print("L'appareil existe déjà.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cet appareil est déjà enregistré.")),
        );
        return;
      }

      // Ajouter l'appareil dans la collection 'devices'
      await _firestore.collection('devices').doc(deviceId).set({
        'deviceId': deviceId,
        'assignedTo': widget.userId,
        'status': 'active',
      });

      // Associer l'appareil à l'utilisateur dans la collection 'users'
      userDevices.add(deviceId);
      await _firestore.collection('users').doc(widget.userId).update({
        'deviceIds': userDevices,
      });

      // Mettre à jour l'interface utilisateur
      setState(() {});
      print("Appareil ajouté : $deviceId");
    } catch (e) {
      print("Erreur lors de l'ajout de l'appareil : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png', width: 40),
            SizedBox(width: 10),
            Text("Sélection de l'appareil",
                style: Theme.of(context).textTheme.headline1),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sélectionnez un appareil existant ou ajoutez-en un nouveau :",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20),
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
                            leading:
                                Icon(Icons.devices, color: AppColors.darkBlue),
                            title: Text(
                              userDevices[index],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkBlue),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagePage(
                                    username: widget.username,
                                    role: 'user',
                                    userId: widget.userId,
                                    deviceId: userDevices[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddDeviceDialog(context);
                },
                icon: Icon(Icons.add),
                label: Text("Ajouter un nouvel appareil"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    TextEditingController deviceIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter un nouvel appareil",
              style: TextStyle(color: AppColors.darkBlue)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: deviceIdController,
                decoration: InputDecoration(
                  labelText: "ID de l'appareil",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child:
                  Text("Annuler", style: TextStyle(color: AppColors.darkBlue)),
            ),
            ElevatedButton(
              onPressed: () async {
                String deviceId = deviceIdController.text.trim();
                if (deviceId.isNotEmpty) {
                  Navigator.pop(context); // Fermer la boîte de dialogue
                  await _addDevice(deviceId); // Ajouter l'appareil
                } else {
                  // Afficher une erreur si l'ID est vide
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Veuillez entrer un ID valide.")),
                  );
                }
              },
              child: Text("Valider", style: TextStyle(color: AppColors.white)),
            ),
          ],
        );
      },
    );
  }
}
