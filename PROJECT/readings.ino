#include <MPU6050.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>
#define DHTPIN 18
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
MPU6050 mpu;
const char* ssid     ="Realme 9pro 5g";
const char* password ="12345678";
int moistureSensorPin = 33;
const int sensor1 = 34; // GPIO pin for raindrop sensor 1
const int sensor2 = 35; // GPIO pin for raindrop sensor 2
const int sensor3 = 32; // GPIO pin for raindrop sensor 3
const int sensor4 = 36; // GPIO pin for raindrop sensor 4

const char* serverName ="http://192.168.3.139:5000/test";
const char* serverUrl ="http://192.168.3.139:5000/update-directions"; // Flask server endpoint

unsigned long lastTime = 0;
unsigned long timerDelay = 1000;


void setup_wifi()
{
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.println("CONNECTING.....");
  }
  Serial.println("CONNECTED");
}

void send_data(String A)
{
  if ((millis() - lastTime) > timerDelay)
  {
    if (WiFi.status() == WL_CONNECTED)
    {
      WiFiClient client;
      HTTPClient http;
      http.begin(client, serverName);
      http.addHeader("Content-Type", "application/x-www-form-urlencoded");
      String httpRequestData = String(A);
      int httpResponseCode = http.POST(httpRequestData);
      Serial.println(httpResponseCode);
      if (httpResponseCode > 0)
      {
        String res = http.getString();
        Serial.println(res);


      }
      http.end();
    }
    else
    {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}

void setup()
{
  Serial.begin(9600);
   pinMode(moistureSensorPin, INPUT);
  setup_wifi();
  dht.begin();
  Wire.begin();
  mpu.initialize();
}

void loop()
{
  //send_data("Hai");
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  //Serial.print(F("Humidity: "));
  //Serial.print(h);
  //Serial.print(F("%  Temperature: "));
  //Serial.println(t);
   int16_t ax, ay, az;
  int16_t gx, gy, gz;
  
  // Get raw accelerometer and gyroscope data
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  
  // Convert acceleration to a smaller range
  float X = ax / 16384.0;  // Convert raw values to g (assuming ±2g range)
  float Y = ay / 16384.0;

  // Calculate the angle in degrees (0-360°)
  float angle = atan2(Y, X) * (180.0 / PI);
  if (angle < 0) {
    angle += 360;  // Convert -180° to 180° into 0° to 360°
  }

  // Print values
  Serial.print("X: "); Serial.print(X);
  
  Serial.print(" Angle: "); Serial.println(angle);

  delay(500);

  int s1 = analogRead(sensor1);
  int s2 = analogRead(sensor2);
  int s3 = analogRead(sensor3);
  int s4 = analogRead(sensor4);
 float moistureValue = analogRead(moistureSensorPin);
  
  float mappedMoistureValue = map(moistureValue, 4095, 0, 0, 10000) / 100.0;
    Serial.print("Moisture Sensor Value: ");
  Serial.println(mappedMoistureValue * 2, 2);
  Serial.println("s1:");
  Serial.println(s1);
  Serial.println("s2:");
  Serial.println(s2);
  Serial.println("s3:");
  Serial.println(s3);
  Serial.println("s4:");
  Serial.println(s4);

  String values = String(t) + "," + String(h) + "," + String(mappedMoistureValue * 2)+ "," + String(s1) + "," + String(s2)+ "," + String(s3)+ "," + String(s4)+ "," + String(angle);
  send_data(values);
  Serial.println(values);
  String direction = determineDirection(s1, s2, s3, s4);
  sendDirection(direction);
  delay(2000); // Send data every 2 seconds
}
String determineDirection(int s1, int s2, int s3, int s4) {
  if (s1 < 4095 && s2 < 4095 && s3 < 4095 && s4 <4095) {
    return "Rain Detected in All Directions";
  } else if (s1 == 4095 && s2 == 4095 && s3 < 4095 && s4 < 4095) {
    return "North-East ";
  } else if (s1< 4095 && s2< 4095) {
    return "North";
  } else if (s3< 4095 && s4 < 4095) {
    return "South";
  } else if (s1 < 4095 && s3 < 4095) {
    return "West";
  } else if (s2 < 4095 && s4 < 4095) {
    return "East";
  } else if (s1< 4095 && s4 < 4095) {
    return "North-West";
  } else if (s2 < 4095 && s3 < 4095) {
    return "South-East";
  } else if (s1< 4095 && s2== 4095 && s3 < 4095 && s4 == 4095) {
    return "North and West";
  } else if (s1 == 4095 && s2 < 4095 && s3== 4095 && s4 < 4095) {
    return "East and South";
  } else if (s1 < 4095 && s2 == 4095 && s3 == 4095 && s4< 4095) {
    return "North-West and South";
  } else if (s1 == 4095 && s2 < 4095 && s3< 4095 && s4 == 4095) {
    return "East and North-East";
  }  else {
    return "No rain";
  }
}
void sendDirection(String direction) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    String jsonPayload = "{\"direction\":\"" + direction + "\"}";
    int httpResponseCode = http.POST(jsonPayload);

    if (httpResponseCode > 0) {
      Serial.println("Direction sent successfully: " + direction);
    } else {
      Serial.println("Error sending direction");
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}
