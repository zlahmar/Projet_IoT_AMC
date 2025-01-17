// #include <MD_Parola.h>
// #include <MD_MAX72xx.h>
// #include <SPI.h>

// #include <Wire.h>

// #include <Adafruit_Sensor.h>
// #include <DHT.h>
// #include <DHT_U.h>
// #include <WiFi.h>
// #include <time.h>
// #include <Adafruit_GFX.h>
// #include <Adafruit_SSD1306.h>

// #include <PubSubClient.h>

// // Configuration Wi-Fi
// const char *ssid = "Zainab";
// const char *password = "zayzay1997";

// // Paramètres pour l'écran OLED
// #define SCREEN_WIDTH 128
// #define SCREEN_HEIGHT 64
// #define OLED_RESET -1
// Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// // Configuration du DHT11
// #define DHTPIN 19
// #define DHTTYPE DHT11
// DHT dht(DHTPIN, DHTTYPE);

// // Configuration de la Matrice LED
// // #define HARDWARE_TYPE MD_MAX72XX::FC16_HW
// // #define MAX_DEVICES 4 // 4 blocks
// // #define CS_PIN 21
// // MD_Parola ledMatrix = MD_Parola(HARDWARE_TYPE, CS_PIN, MAX_DEVICES);

// // Configuration pour l'heure
// const char *ntpServer = "pool.ntp.org";
// const long gmtOffset_sec = 3600;     // Offset pour GMT+1 (France)
// const int daylightOffset_sec = 3600; // Offset pour l'heure d'été

// // Configuration MQTT
// const char *mqtt_server = "broker.emqx.io"; // Adresse du broker MQTT
// const int mqtt_port = 1883;                 // Port par défaut du MQTT
// // const char *mqtt_user = ""; // Utilisateur MQTT, si nécessaire
// // const char *mqtt_pass = ""; // Mot de passe MQTT, si nécessaire

// WiFiClient espClient;
// PubSubClient client(espClient);

// // Variable pour le sujet MQTT
// const char *topic = "AMC/topic";

// void setup()
// {
//   // Initialisation
//   Serial.begin(115200);

//   // Connexion Wi-Fi
//   Serial.print("Connexion au Wi-Fi...");
//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED)
//   {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("Connecté !");

//   // Initialisation de l'heure via NTP
//   configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);

//   // Initialisation des composants
//   // ledMatrix.begin();         // Initialiser la Matrice LED
//   // ledMatrix.setIntensity(5); // Luminosité (de 0 à 15)
//   // ledMatrix.displayClear();  // Nettoyer l'afficheur

//   Wire.begin(21, 22); // SDA = 21, SCL = 22
//   Serial.begin(115200);
//   Serial.println("\nScanning I2C bus...");
//   byte error, address;
//   int devices = 0;
//   for (address = 1; address < 127; address++)
//   {
//     Wire.beginTransmission(address);
//     error = Wire.endTransmission();
//     if (error == 0)
//     {
//       Serial.print("I2C device found at address 0x");
//       Serial.println(address, HEX);
//       devices++;
//     }
//   }
//   if (devices == 0)
//     Serial.println("No I2C devices found");
//   else
//     Serial.println("I2C devices found");

//   dht.begin(); // Initialiser le DHT11

//   // Initialisation de l'écran OLED
//   if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
//   { // Adresse I2C typique : 0x3C
//     Serial.println(F("Échec de l'initialisation de l'écran OLED"));
//     for (;;)
//       ;
//   }
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 0);
//   display.println(F("Initialisation OLED réussie!"));
//   display.display();

//   // Connexion au broker MQTT
//   client.setServer(mqtt_server, mqtt_port);
//   while (!client.connected())
//   {
//     Serial.print("Connexion à MQTT...");
//     if (client.connect("zainab19561997199319922024"))
//     {
//       Serial.println("Connecté !");
//     }
//     else
//     {
//       Serial.print("Échec, code d'erreur : ");
//       Serial.print(client.state());
//       delay(2000);
//     }
//   }
// }

// void loop()
// {
//   // Vérifier la connexion au broker MQTT
//   if (!client.connected())
//   {
//     Serial.println("Connexion perdue au broker MQTT. Reconnexion...");
//     if (client.connect("zainab19561997199319922024"))
//     {
//       Serial.println("Connecté !");
//     }
//     else
//     {
//       Serial.print("Échec, code d'erreur : ");
//       Serial.print(client.state());
//       delay(2000);
//     }
//   }

//   // Récupérer l'heure actuelle
//   struct tm timeinfo;
//   if (!getLocalTime(&timeinfo))
//   {
//     Serial.println("Échec de la synchronisation de l'heure");
//     return;
//   }

//   // Format de l'heure
//   char timeStr[32];
//   strftime(timeStr, sizeof(timeStr), "Heure: %H:%M:%S", &timeinfo);

//   // Lecture des données du DHT11
//   float h = dht.readHumidity();
//   float t = dht.readTemperature();

//   // Vérifier si les données sont valides
//   if (isnan(h) || isnan(t))
//   {
//     Serial.println("Échec de lecture du DHT11");
//     return;
//   }

//   // Texte à afficher
//   char message[128];
//   snprintf(message, sizeof(message), "%s T: %.1fC H: %.1f%%", timeStr, t, h);

//   // Publier les données sur MQTT
//   client.publish(topic, message);
//   Serial.print("Données envoyées : ");
//   Serial.println(message);

//   // Afficher les données sur la matrice LED avec défilement
//   // ledMatrix.displayClear();
//   // ledMatrix.displayScroll(message, PA_CENTER, PA_SCROLL_LEFT, 50);

//   // Attendre que l'animation soit terminée
//   // while (!ledMatrix.displayAnimate())
//   //{
//   //  delay(25); // Petite pause pour l'animation
//   //}

//   // Afficher les données sur l'écran OLED
//   display.clearDisplay();
//   display.setCursor(0, 0);
//   display.println(F("Hello Zay"));
//   display.print(F("Temp: "));
//   display.print(t);
//   display.println(F(" C"));
//   display.print(F("Humid: "));
//   display.print(h);
//   display.println(F(" %"));
//   display.display();

//   delay(1000); // Pause avant de rafraîchir les données
// }
// #include <MD_Parola.h>
// #include <MD_MAX72xx.h>
// #include <SPI.h>

// #include <Wire.h>

// #include <Adafruit_Sensor.h>
// #include <DHT.h>
// #include <DHT_U.h>
// #include <WiFi.h>
// #include <time.h>
// #include <Adafruit_GFX.h>
// #include <Adafruit_SSD1306.h>

// #include <PubSubClient.h>

// // Configuration Wi-Fi
// const char *ssid = "Zainab";
// const char *password = "zayzay1997";

// // Paramètres pour l'écran OLED
// #define SCREEN_WIDTH 128
// #define SCREEN_HEIGHT 64
// #define OLED_RESET -1
// Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// // Configuration MQTT
// const char *mqtt_server = "broker.emqx.io"; // Adresse du broker MQTT
// const int mqtt_port = 1883;                 // Port par défaut du MQTT
// WiFiClient espClient;
// PubSubClient client(espClient);

// // Variable pour le sujet MQTT
// const char *topic = "AMC/topic";

// // Fonction de réception des messages MQTT
// void callback(char *topic, byte *payload, unsigned int length)
// {
//   payload[length] = '\0'; // Terminer la chaîne
//   String message = String((char *)payload);

//   // Afficher le message sur l'écran OLED
//   display.clearDisplay();
//   display.setCursor(0, 0);
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.println("Message reçu:");
//   display.setCursor(0, 20);
//   display.println(message);
//   display.display();
// }

// void setup()
// {
//   // Initialisation
//   Serial.begin(115200);

//   // Connexion Wi-Fi
//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED)
//   {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("Connecté !");

//   // Initialisation de l'écran OLED
//   if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
//   {
//     Serial.println(F("Échec de l'initialisation de l'écran OLED"));
//     for (;;)
//       ;
//   }
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 0);
//   display.println(F("Connecté au Wi-Fi!"));
//   display.display();

//   // Connexion au broker MQTT
//   client.setServer(mqtt_server, mqtt_port);
//   client.setCallback(callback); // Définir la fonction de rappel pour les messages reçus

//   while (!client.connected())
//   {
//     if (client.connect("mqttx_4ef1e7c2"))
//     {
//       Serial.println("Connecté au broker MQTT");
//       client.subscribe(topic); // S'abonner au sujet
//     }
//     else
//     {
//       delay(5000);
//     }
//   }
// }

// void loop()
// {
//   // Maintenir la connexion MQTT active
//   client.loop();
// }
// #include <Wire.h>
// #include <Adafruit_SSD1306.h>
// #include <WiFi.h>
// #include <PubSubClient.h>

// #include <Adafruit_Sensor.h>
// #include <DHT.h>
// #include <DHT_U.h>
// #include <time.h>

// // Configuration Wi-Fi
// const char *ssid = "Zainab";
// const char *password = "zayzay1997";

// // Paramètres pour l'écran OLED
// #define SCREEN_WIDTH 128
// #define SCREEN_HEIGHT 64
// #define OLED_RESET -1
// Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// // Configuration du DHT11
// #define DHTPIN 19
// #define DHTTYPE DHT11
// DHT dht(DHTPIN, DHTTYPE);

// // Configuration MQTT
// const char *mqtt_server = "broker.emqx.io"; // Adresse du broker MQTT
// const int mqtt_port = 1883;                 // Port par défaut du MQTT
// WiFiClient espClient;
// PubSubClient client(espClient);

// // Variables pour MQTT et le mode
// const char *topicMode = "AMC/topic/mode";       // Sujet pour changer de mode
// const char *topicMessage = "AMC/topic/message"; // Sujet pour recevoir des messages
// String mode = "message";                        // Mode actuel : "message" ou "affichage"

// // Fonction de réception des messages MQTT
// void callback(char *topic, byte *payload, unsigned int length)
// {
//   payload[length] = '\0'; // Terminer la chaîne
//   String message = String((char *)payload);

//   // Gestion du changement de mode
//   if (String(topic) == topicMode)
//   {
//     mode = message;
//     Serial.println("Mode changé : " + mode);
//   }

//   // Gestion des messages dans le mode "message"
//   if (mode == "message" && String(topic) == topicMessage)
//   {
//     display.clearDisplay();
//     display.setCursor(0, 0);
//     display.setTextSize(1);
//     display.setTextColor(SSD1306_WHITE);
//     display.println("Message reçu:");
//     display.setCursor(0, 20);
//     display.println(message);
//     display.display();
//   }
// }

// void setup()
// {
//   // Initialisation
//   Serial.begin(115200);
//   dht.begin();

//   // Connexion Wi-Fi
//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED)
//   {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("Connecté au Wi-Fi!");

//   // Initialisation de l'écran OLED
//   if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
//   {
//     Serial.println(F("Échec de l'initialisation de l'écran OLED"));
//     for (;;)
//       ;
//   }
//   display.clearDisplay();
//   display.setTextSize(1);
//   display.setTextColor(SSD1306_WHITE);
//   display.setCursor(0, 0);
//   display.println(F("Connecté au Wi-Fi!"));
//   display.display();

//   // Connexion au broker MQTT
//   client.setServer(mqtt_server, mqtt_port);
//   client.setCallback(callback);

//   while (!client.connected())
//   {
//     if (client.connect("Zainab212ESP32Client"))
//     {
//       Serial.println("Connecté au broker MQTT");
//       client.subscribe(topicMode);    // S'abonner au sujet de changement de mode
//       client.subscribe(topicMessage); // S'abonner au sujet de réception des messages
//     }
//     else
//     {
//       Serial.print("Échec, code d'erreur : ");
//       Serial.print(client.state());
//       delay(5000);
//     }
//   }
// }

// void loop()
// {
//   // Maintenir la connexion MQTT active
//   client.loop();

//   // Mode affichage : Afficher l'heure, la température et l'humidité
//   if (mode == "affichage")
//   {
//     float temp = dht.readTemperature();
//     float humidity = dht.readHumidity();

//     if (isnan(temp) || isnan(humidity))
//     {
//       Serial.println("Erreur de lecture du DHT11 !");
//       return;
//     }

//     // Affichage sur l'écran OLED
//     display.clearDisplay();
//     display.setTextSize(1);
//     display.setTextColor(SSD1306_WHITE);
//     display.setCursor(0, 0);
//     display.println("Mode: Affichage");

//     display.setCursor(0, 20);
//     display.print("Temp: ");
//     display.print(temp);
//     display.println(" C");

//     display.setCursor(0, 35);
//     display.print("Hum: ");
//     display.print(humidity);
//     display.println(" %");

//     display.setCursor(0, 50);
//     display.print("Heure: ");
//     display.print(hour());
//     display.print(":");
//     display.println(minute());

//     display.display();

//     delay(5000); // Mise à jour toutes les 5 secondes
//   }
// }
