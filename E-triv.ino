#include <ArduinoBLE.h>
#include <Adafruit_NeoPixel.h>
#include <Arduino_LSM9DS1.h>

// built in LED
const int ledPin = 13; 
// LED control
#define PIN 6 
// number of LEDs
#define NUMPIXELS 5
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

BLEService BLE_Service("af565a71-01c0-4a19-829f-86ae5800efed");
BLEStringCharacteristic BLE_Characteristics("474d9179-b87b-42d8-b954-135be2fa94c6", BLERead | BLENotify | BLEWrite | BLEWriteWithoutResponse, 100);

void setup() {
  // Start serial for debugging
  Serial.begin(9600);

  // Make sure LEDs light up
  pixels.begin();
  pixels.clear(); 
  pixels.setPixelColor(0, pixels.Color(0, 150, 0));
  pixels.setPixelColor(1, pixels.Color(0, 150, 0));
  pixels.setPixelColor(2, pixels.Color(0, 150, 0));
  pixels.setPixelColor(3, pixels.Color(0, 150, 0));
  pixels.setPixelColor(4, pixels.Color(0, 150, 0));
  pixels.show(); 

  // Initialize built in LED
  pinMode(ledPin, OUTPUT);

  // IMU code for posture monitoring
  if (!IMU.begin()) {
    Serial.println("failed to initialize IMU");
    // while (1); // for debugging
  }

  // Initialize BLE communication 
  if (!BLE.begin()) {
    Serial.println("failed to start BLE");
    while (1);
  }
  BLE.setLocalName("E-Triv-Arduino");
  BLE.setAdvertisedService(BLE_Service);
  BLE_Service.addCharacteristic(BLE_Characteristics);
  BLE.addService(BLE_Service);
  BLE.advertise();
  Serial.println("Bluetooth actived, waiting for a connection");

} //end setup()


int counter = 0;
int battery_percentage = 0;
float x, y, z;


void loop() {
  // Serial.println("stuck1?");
  // Posture monitoring
  if (IMU.accelerationAvailable()) {
    // Serial.println("stuck2?");
    IMU.readAcceleration(y, x, z);
    // Serial.print("X = "); // for debugging
    // Serial.print(x); // for debugging
    // Serial.print(", Y = "); // for debugging
    // Serial.print(y); // for debugging
    // Serial.print(", Z = "); // for debugging
    // Serial.println(z); // for debugging
  }
  // Serial.println("stuck3?");
  if (y < 0.9 && y > -0.9) {
    digitalWrite(ledPin, HIGH); // for debugging
    // TODO: send message to app posture no good
  } 
  else {
    digitalWrite(ledPin, LOW);// for debugging
  }

  // Battery monitoring
  // Print the sensor value to the serial monitor 
  counter++;
  // Serial.println(counter);
  if (counter == 2000) {
    int sensorValue = analogRead(A0);
    if(sensorValue > 850) {
      battery_percentage = 100;
    } 
    else if (sensorValue < 835 && sensorValue > 770) {
      battery_percentage = 75;
    } 
    else if (sensorValue < 755 && sensorValue > 730) {
      battery_percentage = 50;
    } 
    else if (sensorValue < 715 && sensorValue > 680) {
      battery_percentage = 25;
    } 
    else if (sensorValue < 665) {
      battery_percentage = 0;
    }
    // TODO: send battery_percentage to app

    // Serial.print("Analog Value: "); // for debugging
    // Serial.println(sensorValue); // for debugging
    // Serial.print("Battery Percentage: "); // for debugging
    // Serial.println(battery_percentage);
    counter = 0;
  }

  // BLE message handling
  BLEDevice central = BLE.central();
  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    while (central.connected()) {

      // Handle BLE events (received messages) 
      BLE.poll();
      if (BLE_Characteristics.written()) {
        String value = BLE_Characteristics.value();
        Serial.print("Received value: "); 
        Serial.println(value);


        //**TODO** - send/receive String replies from arduino; begin handling sensor stuff
        if (value == "g") {      
          String reply = "henlo";
          Serial.println("Sending reply: " + reply);
          BLE_Characteristics.writeValue(reply);
        }
        else if (value.length() == 8) { // no custom thing yet so I'm checking if the message is of length 8
          String reply = value;
          Serial.println("Sending reply: " + reply);
          BLE_Characteristics.writeValue(reply);

          String alphaValue = value.substring(0, 2);
          String redValue = value.substring(2, 4);
          String greenValue = value.substring(4, 6);
          String blueValue = value.substring(6, 8);

          long alpha = strtol(alphaValue.c_str(), NULL, 16);
          long red = strtol(redValue.c_str(), NULL, 16);
          long green = strtol(greenValue.c_str(), NULL, 16);
          long blue = strtol(blueValue.c_str(), NULL, 16);

          for(int i=0; i<NUMPIXELS; i++) {
            pixels.setPixelColor(i, pixels.Color(red * ((double)alpha/255), green * ((double)alpha/255), blue * ((double)alpha/255)));
            pixels.show();
          }
        }
        else {
          String reply = "no";
          Serial.println("Sending reply: " + reply);
          BLE_Characteristics.writeValue(reply);
        }


      }      
    }
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
  
  // old chat code
  // if(value == "G"  || value == "g") {
  //   pixels.setPixelColor(0, pixels.Color(0, 150, 0));
  //   pixels.show();   
  // }
  // else if(value == "B" || value == "b") {
  //   pixels.setPixelColor(0, pixels.Color(0, 0, 150));
  //   pixels.show();  
  // }
  // else if(value == "R" || value == "r") {
  //   pixels.setPixelColor(0, pixels.Color(150, 0, 0));
  //   pixels.show();  
  // }

} //end loop()

