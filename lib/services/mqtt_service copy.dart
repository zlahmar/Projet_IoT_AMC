// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:convert';

// class MqttService {
//   final MqttServerClient client;

//   MqttService(String broker, String clientId)
//       : client = MqttServerClient(broker, _sanitizeClientId(clientId)) {
//     client.port = 1883; // Port MQTT par défaut
//     client.logging(on: true);
//     client.keepAlivePeriod = 20;
//     client.onConnected = onConnected;
//     client.onDisconnected = onDisconnected;
//     client.onSubscribed = onSubscribed;
//     if (!kIsWeb) {
//       // Effectuez les connexions MQTT uniquement sur mobile/desktop
//     }
//   }

//   // Méthode pour se connecter au broker MQTT
//   Future<void> connect() async {
//     try {
//       client.connectionMessage = MqttConnectMessage()
//           .withClientIdentifier('flutter_client')
//           .startClean() // Nettoie les sessions précédentes
//           .withWillTopic('AMC/topic') // Sujet de la "Last Will and Testament"
//           .withWillMessage('Client déconnecté')
//           .withWillQos(MqttQos.atLeastOnce);

//       await client.connect();
//     } catch (e) {
//       print('Erreur de connexion : $e');
//       disconnect();
//     }
//   }

//   // Déconnexion
//   void disconnect() {
//     client.disconnect();
//   }

//   // Envoi d'un message au microcontrôleur avec un traitement des caractères spéciaux
//   void publishMessage(String topic, String message) {
//     final builder = MqttClientPayloadBuilder();
//     // Convertir le message en base64 pour éviter des problèmes d'encodage avec des caractères spéciaux
//     String encodedMessage = base64Encode(utf8.encode(message));
//     builder.addString(encodedMessage);
//     client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
//   }

//   // Abonnement à un sujet
//   void subscribe(String topic) {
//     client.subscribe(topic, MqttQos.atLeastOnce);
//   }

//   // Gestion des événements
//   static void onConnected() {
//     print('Connecté au broker MQTT');
//   }

//   static void onDisconnected() {
//     print('Déconnecté du broker MQTT');
//   }

//   static void onSubscribed(String topic) {
//     print('Abonné au sujet : $topic');
//   }

//   bool isConnected() {
//     return client.connectionStatus?.state == MqttConnectionState.connected;
//   }

//   // Fonction pour s'assurer que le clientId est valide
//   static String _sanitizeClientId(String clientId) {
//     // Retirer les caractères spéciaux du clientId
//     return clientId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
//   }
// }
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final String broker; // Adresse du broker MQTT
  final String clientId; // ID du client
  late MqttServerClient _client; // Instance du client MQTT
  Function(String topic, String message)?
      onMessageReceived; // Callback pour les messages reçus

  MqttService(this.broker, this.clientId);

  /// Initialisation et connexion au broker MQTT
  Future<void> connect() async {
    _client = MqttServerClient(broker, clientId)
      ..port = 1883
      ..logging(on: true)
      ..keepAlivePeriod = 20
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..onSubscribed = _onSubscribed
      ..onSubscribeFail = _onSubscribeFail
      ..onUnsubscribed = _onUnsubscribed;

    _client.setProtocolV311(); // Définir la version du protocole
    _client.autoReconnect = true; // Reconnexion automatique

    _client.onConnected = () {
      print('Connexion réussie au broker MQTT.');
    };

    try {
      print('Connexion au broker MQTT...');
      final connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillTopic('willtopic') // Sujet pour le message de dernier vœu
          .withWillMessage('Déconnexion inattendue du client.')
          .withWillRetain()
          .withWillQos(MqttQos.atLeastOnce);
      _client.connectionMessage = connMessage;

      await _client.connect();
    } catch (e) {
      print('Erreur lors de la connexion MQTT : $e');
      _client.disconnect();
      throw e;
    }

    // Gestion des messages reçus
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('Message reçu sur le sujet: ${c[0].topic}, message: $payload');
      if (onMessageReceived != null) {
        onMessageReceived!(c[0].topic, payload);
      }
    });
  }

  /// Déconnexion du broker MQTT
  void disconnect() {
    _client.disconnect();
    print('Déconnecté du broker MQTT.');
  }

  /// S'abonner à un sujet
  void subscribe(String topic) {
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      print('Abonné au sujet : $topic');
    } else {
      print('Impossible de s’abonner : Client non connecté.');
    }
  }

  /// Publier un message sur un sujet
  void publish(String topic, String message) {
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print('Message publié : $message sur le sujet : $topic');
    } else {
      print('Impossible de publier : Client non connecté.');
    }
  }

  // Callbacks pour gérer les événements MQTT
  void _onConnected() {
    print('Connecté au broker MQTT.');
  }

  void _onDisconnected() {
    print('Déconnecté du broker MQTT.');
  }

  void _onSubscribed(String topic) {
    print('Abonné au sujet : $topic');
  }

  void _onSubscribeFail(String topic) {
    print('Échec de l’abonnement au sujet : $topic');
  }

  void _onUnsubscribed(String? topic) {
    print('Désabonné du sujet : $topic');
  }

  bool isConnected() {
    return _client.connectionStatus!.state == MqttConnectionState.connected;
  }
}
