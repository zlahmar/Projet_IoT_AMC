import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des utilisateurs"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final usersDocs = snapshot.data!.docs;

          if (usersDocs.isEmpty) {
            return Center(child: Text("Aucun utilisateur trouvé."));
          }

          return ListView.builder(
            itemCount: usersDocs.length,
            itemBuilder: (context, index) {
              var user = usersDocs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(user['username'] ?? 'Utilisateur'),
                  subtitle: Text("Role: ${user['role'] ?? 'user'}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      _updateUserRole(usersDocs[index].id, value);
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'user',
                          child: Text("Définir comme Utilisateur"),
                        ),
                        PopupMenuItem(
                          value: 'admin',
                          child: Text("Définir comme Administrateur"),
                        ),
                      ];
                    },
                    child: Icon(Icons.more_vert),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      print("Rôle mis à jour avec succès.");
    } catch (e) {
      print("Erreur lors de la mise à jour du rôle : $e");
    }
  }
}
