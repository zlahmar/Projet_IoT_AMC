import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final String broker; // Adresse du broker MQTT
  final int port; // Port MQTT
  final String clientId; // Identifiant unique du client
  late MqttServerClient _client;

  // Callback pour les messages reçus
  void Function(String topic, String message)? onMessageReceived;

  // Constructeur
  MqttService({
    required this.broker,
    required this.port,
    required this.clientId,
  }) {
    _client = MqttServerClient(broker, clientId)
      ..port = port
      ..logging(on: true)
      ..keepAlivePeriod = 20
      ..setProtocolV311()
      ..autoReconnect = true
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected
      ..onSubscribed = onSubscribed
      ..onUnsubscribed = onUnsubscribed
      ..onSubscribeFail = onSubscribeFail
      ..pongCallback = onPong;
  }

  /// Connexion au broker MQTT
  Future<void> connect() async {
    try {
      final connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillTopic('AMC/topic') // Sujet du dernier message
          .withWillMessage('Déconnexion inattendue de $clientId')
          .withWillRetain()
          .withWillQos(MqttQos.atLeastOnce);
      _client.connectionMessage = connMessage;

      await _client.connect();
      if (_client.connectionStatus?.state == MqttConnectionState.connected) {
        print('Connecté au broker MQTT.');
      } else {
        print('Erreur de connexion : ${_client.connectionStatus?.state}');
        _client.disconnect();
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      _client.disconnect();
      throw e;
    }
  }

  /// Publier un message
  void publish(String topic, String message) {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print('Message publié : $message sur le sujet : $topic');
    } else {
      print('Impossible de publier : Client non connecté.');
    }
  }

  /// S'abonner à un sujet
  void subscribe(String topic) {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      print('Abonné au sujet : $topic');
    } else {
      print('Impossible de s\'abonner : Client non connecté.');
    }
  }

  /// Gérer les messages reçus
  void _onMessage(List<MqttReceivedMessage<MqttMessage?>> events) {
    final MqttReceivedMessage<MqttMessage?> message = events[0];
    final payload = (message.payload as MqttPublishMessage).payload.message;

    final messageContent = MqttPublishPayload.bytesToStringAsString(payload);
    print('Message reçu sur ${message.topic} : $messageContent');

    // Appeler le callback si défini
    if (onMessageReceived != null) {
      onMessageReceived!(message.topic, messageContent);
    }
  }

  // Callbacks pour les événements MQTT
  void onConnected() {
    print('Connecté au broker MQTT.');
    _client.updates?.listen(_onMessage); // Écoute des messages reçus
  }

  bool isConnected() {
    return _client.connectionStatus?.state == MqttConnectionState.connected;
  }

  void onDisconnected() {
    print('Déconnecté du broker MQTT.');
  }

  void onSubscribed(String topic) {
    print('Abonné avec succès au sujet : $topic');
  }

  void onUnsubscribed(String? topic) {
    print('Désabonné du sujet : $topic');
  }

  void onSubscribeFail(String topic) {
    print('Échec de l\'abonnement au sujet : $topic');
  }

  void onPong() {
    print('Pong reçu du broker MQTT.');
  }
}
