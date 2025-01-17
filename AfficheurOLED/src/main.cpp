#include <Wire.h>
#include <Adafruit_SSD1306.h>
#include <WiFi.h>
#include <PubSubClient.h>

#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <time.h>

// Configuration Wi-Fi
const char *ssid = "Zainab";
const char *password = "zayzay1997";

// Configuration NTP
const long gmtOffset_sec = 3600;        // Offset GMT en secondes
const int daylightOffset_sec = 3600;    // Offset de l'heure d'été en secondes
const char *ntpServer = "pool.ntp.org"; // Serveur NTP

// Paramètres pour l'écran OLED
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Configuration du DHT11
#define DHTPIN 19
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Configuration MQTT
const char *mqtt_server = "broker.emqx.io"; // Adresse du broker MQTT
const int mqtt_port = 1883;                 // Port par défaut du MQTT
WiFiClient espClient;
PubSubClient client(espClient);

// Variables pour MQTT et le mode
const char *topicMode = "AMC/topic/mode";       // Sujet pour changer de mode
const char *topicMessage = "AMC/topic/message"; // Sujet pour recevoir des messages
String mode = "message";                        // Mode actuel : "message" ou "affichage"

// Fonction de réception des messages MQTT
void callback(char *topic, byte *payload, unsigned int length)
{
  payload[length] = '\0'; // Terminer la chaîne
  String message = String((char *)payload);

  // Gestion du changement de mode
  if (String(topic) == topicMode)
  {
    mode = message;
    Serial.println("Mode changé : " + mode);
  }

  // Gestion des messages dans le mode "message"
  if (mode == "message" && String(topic) == topicMessage)
  {
    display.clearDisplay();
    display.setCursor(0, 0);
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.println("Message reçu:");
    display.setCursor(0, 20);
    display.println(message);
    display.display();
  }
}

void setup()
{
  // Initialisation
  Serial.begin(115200);
  dht.begin();

  // Connexion Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connecté au Wi-Fi!");

  // Initialisation de l'heure via NTP
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);

  // Initialisation de l'écran OLED
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
  {
    Serial.println(F("Échec de l'initialisation de l'écran OLED"));
    for (;;)
      ;
  }
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("Connecté au Wi-Fi!"));
  display.display();

  // Connexion au broker MQTT
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  while (!client.connected())
  {
    if (client.connect("Zainab212ESP32Client"))
    {
      Serial.println("Connecté au broker MQTT");
      client.subscribe(topicMode);    // S'abonner au sujet de changement de mode
      client.subscribe(topicMessage); // S'abonner au sujet de réception des messages
    }
    else
    {
      Serial.print("Échec, code d'erreur : ");
      Serial.print(client.state());
      delay(5000);
    }
  }
}

void loop()
{
  // Maintenir la connexion MQTT active
  client.loop();

  // Mode affichage : Afficher l'heure, la température et l'humidité
  if (mode == "affichage")
  {
    float temp = dht.readTemperature();
    float humidity = dht.readHumidity();

    if (isnan(temp) || isnan(humidity))
    {
      Serial.println("Erreur de lecture du DHT11 !");
      return;
    }
    //   // Récupérer l'heure actuelle
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo))
    {
      Serial.println("Échec de la synchronisation de l'heure");
      return;
    }
    // Format de l'heure
    char timeStr[32];
    strftime(timeStr, sizeof(timeStr), "Heure: %H:%M:%S", &timeinfo);

    // Affichage sur l'écran OLED
    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.println("Mode: Affichage");

    display.setCursor(0, 20);
    display.print("Temp: ");
    display.print(temp);
    display.println(" C");

    display.setCursor(0, 35);
    display.print("Hum: ");
    display.print(humidity);
    display.println(" %");

    display.setCursor(0, 50);
    display.print("Heure: ");
    display.print(timeStr);

    display.display();

    delay(5000); // Mise à jour toutes les 5 secondes
  }
}
