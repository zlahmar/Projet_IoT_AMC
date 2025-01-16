import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  final String deviceId;

  HistoryPage({required this.deviceId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (deviceId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Historique des Messages"),
        ),
        body: Center(
          child: Text("Aucun identifiant d'appareil fourni."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Historique des Messages"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('history')
            .where('deviceId', isEqualTo: deviceId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Affichage en attendant les données
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final historyDocs = snapshot.data!.docs;

          // Aucune donnée trouvée
          if (historyDocs.isEmpty) {
            return Center(child: Text("Aucun historique pour cet appareil."));
          }

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              var history = historyDocs[index].data() as Map<String, dynamic>;

              // Débogage : Afficher ce que nous avons reçu
              print("Data received: ${history['message']}");
              print("Timestamp: ${history['timestamp']}");

              // Si timestamp est un Timestamp Firestore, utiliser cette ligne :
              DateTime timestamp = (history['timestamp'] is Timestamp)
                  ? (history['timestamp'] as Timestamp).toDate()
                  : DateTime
                      .now(); // Si ce n'est pas un Timestamp, utiliser la date actuelle (juste pour éviter un crash)

              return ListTile(
                title: Text(history['message']),
                subtitle: Text(
                    "Par: ${history['username']} - ${timestamp.toString()}"),
              );
            },
          );
        },
      ),
    );
  }
}
