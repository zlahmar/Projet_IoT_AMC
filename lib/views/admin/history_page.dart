import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  final String deviceId;

  HistoryPage({required this.deviceId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final historyDocs = snapshot.data!.docs;

          if (historyDocs.isEmpty) {
            return Center(child: Text("Aucun historique pour cet appareil."));
          }

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              var history = historyDocs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(history['message']),
                subtitle: Text(
                    "Par: ${history['username']} - ${DateTime.fromMillisecondsSinceEpoch(history['timestamp'].millisecondsSinceEpoch)}"),
              );
            },
          );
        },
      ),
    );
  }
}
