//Gestion de la communication MQTTimport 'package:mqtt_client/mqtt_client.dart';
/*
class MqttService {
  final MqttClient _client = MqttClient('mqtt.yourbroker.com', '');

  MqttService() {
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
  }

  Future<void> connect() async {
    await _client.connect();
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void _onDisconnected() {
    print('MQTT Client disconnected');
  }
}
*/