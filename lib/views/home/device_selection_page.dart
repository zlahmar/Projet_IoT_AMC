import 'package:flutter/material.dart';
import '../home/message_page.dart';

class DeviceSelectionPage extends StatelessWidget {
  final String username; // Ajout du paramètre username pour l'utilisateur
  final List<String> previousDevices = ["Device 1", "Device 2", "Device 3"];

  DeviceSelectionPage(
      {required this.username}); // Constructeur pour récupérer l'username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sélection de l'appareil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sélectionnez un appareil existant ou ajoutez-en un nouveau :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: previousDevices.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.devices, color: Colors.blue),
                      title: Text(
                        previousDevices[index],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Redirection vers MessagePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagePage(
                              username: username, // Passage de l'username
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
                  _showAddDeviceDialog(
                      context); // Affiche la boîte de dialogue pour ajouter un appareil
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
          title: Text("Ajouter un nouvel appareil"),
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
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                String deviceId = deviceIdController.text.trim();
                if (deviceId.isNotEmpty) {
                  // Ajouter la logique pour enregistrer le nouvel appareil ici
                  print("Nouveau device ajouté : $deviceId");

                  // Redirection vers la page des messages
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePage(username: username),
                    ),
                  );
                } else {
                  // Afficher une erreur si l'ID est vide
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Veuillez entrer un ID valide.")),
                  );
                }
              },
              child: Text("Valider"),
            ),
          ],
        );
      },
    );
  }
}
