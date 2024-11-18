import 'package:flutter/material.dart';
import '../home/home_page.dart';

class DeviceSelectionPage extends StatelessWidget {
  final List<String> previousDevices = ["Device 1", "Device 2", "Device 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sélection de l'appareil")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Sélectionnez un appareil ou ajoutez-en un nouveau :",
                style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: previousDevices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(previousDevices[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePage(deviceId: previousDevices[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Ajouter un nouvel appareil
              },
              child: Text("Ajouter un nouvel appareil"),
            ),
          ],
        ),
      ),
    );
  }
}
