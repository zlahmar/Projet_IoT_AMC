//Gestion des interactions avec Firebase (auth, database)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // **Users Collection**
  Future<void> addUser(
      String uid, String username, String email, String role) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'role': role,
      'deviceIds': [],
    });
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserDevices(String uid, List<String> deviceIds) async {
    await _firestore.collection('users').doc(uid).update({
      'deviceIds': deviceIds,
    });
  }

  // **Devices Collection**
  Future<void> addDevice(String deviceId) async {
    await _firestore.collection('devices').doc(deviceId).set({
      'deviceId': deviceId,
      'assignedTo': null,
      'status': 'inactive',
    });
  }

  Future<void> updateDeviceStatus(
      String deviceId, String status, String? assignedTo) async {
    await _firestore.collection('devices').doc(deviceId).update({
      'status': status,
      'assignedTo': assignedTo,
    });
  }

  // **DeviceParams Collection**
  Future<void> setDeviceParams(
      String deviceId, String mode, int scrollSpeed, int sensitivity) async {
    await _firestore.collection('deviceParams').doc(deviceId).set({
      'deviceId': deviceId,
      'mode': mode,
      'scrollSpeed': scrollSpeed,
      'sensitivity': sensitivity,
    });
  }

  Future<DocumentSnapshot> getDeviceParams(String deviceId) async {
    return await _firestore.collection('deviceParams').doc(deviceId).get();
  }

  // **History Collection**
  Future<void> addHistory(
      String deviceId, String username, String message) async {
    await _firestore.collection('history').add({
      'deviceId': deviceId,
      'timestamp': FieldValue.serverTimestamp(),
      'username': username,
      'message': message,
    });
  }

  Future<QuerySnapshot> getHistory(String deviceId) async {
    return await _firestore
        .collection('history')
        .where('deviceId', isEqualTo: deviceId)
        .orderBy('timestamp', descending: true)
        .get();
  }
}
