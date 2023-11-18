#include <ArduinoBLE.h>
#include <Adafruit_NeoPixel.h>
#include <Arduino_LSM9DS1.h>

// Built-in LED
const int ledPin = 13; 
// LED control
#define PIN 6 
// Number of LEDs
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

  // Initialize built-in LED
  pinMode(ledPin, OUTPUT);

  // IMU code for posture monitoring
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU");
    // while (1); // for debugging
  }

  // Initialize BLE communication 
  if (!BLE.begin()) {
    Serial.println("Failed to start BLE");
    while (1);
  }
  Serial.println("Bluetooth activated, waiting for a connection");
  BLE.setLocalName("E-Triv-Arduino");
  BLE.setAdvertisedService(BLE_Service);
  BLE_Service.addCharacteristic(BLE_Characteristics);
  BLE.addService(BLE_Service);
  BLE.advertise();

} //end setup() 


int counter = 0;
int battery_percentage = 0;
float x, y, z;
unsigned long batteryCheckInterval = 3000;  // Check battery every 3 seconds
unsigned long lastBatteryCheckTime = 0;


void loop() {  
  unsigned long currentMillis = millis();

  /* ----- Posture Monitoring ----- */
  // Serial.println("stuck1?");
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
    digitalWrite(ledPin, LOW); // for debugging
  }

  

  /* ----- BLE Message Handling ----- */
  BLEDevice central = BLE.central();
  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    while (central.connected()) {
      // Handle BLE events (received messages) 
      BLE.poll();



      //**TODO** -- FRI: fix color issue with battery charge indicator!!
      // currently I send it 100 and it turns all yellow 

      /* ----- Battery Monitoring ----- */
      // Reads pin for battery percentage, then sends that value to the app for users to see
      counter++;
      //Serial.println(counter);
      if (counter == 2000) {
        //int sensorValue = analogRead(A0);  // To run normally: uncomment this line and comment the below line
        int sensorValue = 860;  // To test: uncomment this line and comment the above line
        if (sensorValue >= 850) {
          battery_percentage = 100;          
          Serial.println("Sending battery charge: 100%");
          BLE_Characteristics.writeValue(String(battery_percentage));
        } 
        else if (sensorValue < 850 && sensorValue >= 770) {  //else if (sensorValue < 835 && sensorValue > 770)
          battery_percentage = 75;
          Serial.println("Sending battery charge: 75%");
          BLE_Characteristics.writeValue(String(battery_percentage));
        } 
        else if (sensorValue < 770 && sensorValue >= 730) {  //else if (sensorValue < 755 && sensorValue > 730)
          battery_percentage = 50;
          Serial.println("Sending battery charge: 50%");
          BLE_Characteristics.writeValue(String(battery_percentage));
        } 
        else if (sensorValue < 730 && sensorValue >= 665) {  //else if (sensorValue < 715 && sensorValue > 680)
          battery_percentage = 25;
          Serial.println("Sending battery charge: 25%");
          BLE_Characteristics.writeValue(String(battery_percentage));
        } 
        else if (sensorValue < 665) {
          battery_percentage = 0;
          Serial.println("Sending battery charge: 0%");
          BLE_Characteristics.writeValue(String(battery_percentage));
        }
        // Serial.print("Analog Value: "); // for debugging
        // Serial.println(sensorValue); // for debugging
        // Serial.print("Battery Percentage: "); // for debugging
        // Serial.println(battery_percentage);
        counter = 0;
      }


      // Battery Monitoring Section:
      // if (currentMillis - lastBatteryCheckTime >= batteryCheckInterval) {
      //   // Perform battery monitoring only every 3 seconds
      //   lastBatteryCheckTime = currentMillis;  // Update last check time
      //   int sensorValue = 900;  // Replace with actual analogRead(A0) code
      //   // Determine battery percentage based on sensorValue
      //   if (sensorValue > 850) {
      //     battery_percentage = 100;
      //   } 
      //   else if (sensorValue < 835 && sensorValue > 770) {
      //     battery_percentage = 75;
      //   } 
      //   else if (sensorValue < 755 && sensorValue > 730) {
      //     battery_percentage = 50;
      //   } 
      //   else if (sensorValue < 715 && sensorValue > 680) {
      //     battery_percentage = 25;
      //   } 
      //   else if (sensorValue < 665) {
      //     battery_percentage = 0;
      //   }
      //   // Print battery charge percentage to the serial monitor
      //   Serial.print("Sending battery charge: ");
      //   Serial.print(battery_percentage);
      //   Serial.println("%");
      //   // Convert battery percentage to a string
      //   String batChargeStr = String(battery_percentage);
      //   // Send battery charge percentage to the central device
      //   BLE_Characteristics.writeValue(batChargeStr);
      // }



      /* ----- SOS LEAF ----- */
      // Arduino detects when SOS button has been pressed and sends "SOS" string to the app so app can SMS contacts     
      //if ( sos button press detected by Arduino ) {  //TODO: uncomment this then add some code for sos button press detection
      //   Serial.println("Sending SOS msg: SOS");
      //   BLE_Characteristics.writeValue("SOS");
      // }
      // // This checks that SOS text was sent from the app
      // if (BLE_Characteristics.written() && (BLE_Characteristics.value() == "Sent SOS SMS!")) {
      //   Serial.print("App sent SOS SMS!");
      // }      



      /* ----- HEALTH LEAF ----- */
      //**TODO** -- health/posture things



      /* ----- LIGHT LEAF ----- */
      // Checks for color &/or pattern requests from the app and handles them
      if (BLE_Characteristics.written()) {
        String value = BLE_Characteristics.value();  // Received String value from the app
        Serial.println("Received value from app: " + value); 

        // ***Chat page test**
        if (value == "test") {
          String reply = "test test";  // Can change reply msg to app here
          Serial.println("Sending reply: " + reply);
          BLE_Characteristics.writeValue(reply);
        }
        // App request to just change light leaf color
        else if (value.length() == 8) {
          // Acknowledge app request and sent hex color code back to the app
          Serial.println("Acknowledging change color request: " + value);
          BLE_Characteristics.writeValue(value);
          // Extract value parts
          String alphaValue = value.substring(0, 2);
          String redValue = value.substring(2, 4);
          String greenValue = value.substring(4, 6);
          String blueValue = value.substring(6, 8);
          // Convert strings to longs
          long alpha = strtol(alphaValue.c_str(), NULL, 16);
          long red = strtol(redValue.c_str(), NULL, 16);
          long green = strtol(greenValue.c_str(), NULL, 16);
          long blue = strtol(blueValue.c_str(), NULL, 16);
          // Set pixels
          for (int i=0; i<NUMPIXELS; i++) {
            pixels.setPixelColor(i, pixels.Color(red * ((double)alpha/255), green * ((double)alpha/255), blue * ((double)alpha/255)));
            pixels.show();
          }
        }
        // App request to change light leaf color + pattern
        else if (value.length() == 13) {
          // Acknowledge app request and sent hex color code back to the app
          Serial.println("Acknowledging change color + pattern request: " + value);
          BLE_Characteristics.writeValue(value);
          //Extract value parts
          String patternValue = value.substring(0,5);
          String alphaValue = value.substring(5, 7);
          String redValue = value.substring(7, 9);
          String greenValue = value.substring(9, 11);
          String blueValue = value.substring(11, 13);
          //Convert strings to longs
          long alpha = strtol(alphaValue.c_str(), NULL, 16);
          long red = strtol(redValue.c_str(), NULL, 16);
          long green = strtol(greenValue.c_str(), NULL, 16);
          long blue = strtol(blueValue.c_str(), NULL, 16);
          //Set pixels
          if (patternValue == "Solid") {
            Serial.println("Setting Solid light leaf pattern.");
            for (int i = 0; i < NUMPIXELS; i++) {
              pixels.setPixelColor(i, pixels.Color(red * ((double)alpha / 255), green * ((double)alpha / 255), blue * ((double)alpha / 255)));
            }
            pixels.show();
          } 
          else if (patternValue == "Flash") {
            // **TODO** -- test flash light pattern!
            Serial.println("Setting Flash light leaf pattern.");  
            flashPattern(alpha, red, green, blue);  // Call Flash pattern function   
          } 
          else if (value == "AAAAAAAAAAAAA") {  // App request to enable lights
            // **TODO** -- test enable lights!
            Serial.println("Enabling lights");
            for (int i=0; i<NUMPIXELS; i++) {
              pixels.setPixelColor(i, pixels.Color(150, 150, 150));
              pixels.show();
            }
          } 
          else if (value == "ZZZZZZZZZZZZZ") {  // App request to disable lights (actually just turn them off)
            // **TODO** -- test disable lights!
            Serial.println("Disabling lights");
            for (int i=0; i<NUMPIXELS; i++) {
              pixels.setPixelColor(i, pixels.Color(0, 0, 0));
              pixels.show();
            }
          } 
          else {
            Serial.println("Error unexpected light leaf request.");
          }
        }   
        // ***SOS page test*** 
        else if (value.length() == 3) {
          // Tests that Arduino gets/responds to app SOS enable/disable
          if (value == "AAA") {  // App request to enable SOS leaf
            Serial.println("Sending reply: " + value);
            BLE_Characteristics.writeValue(value);
          }
          else if (value == "ZZZ") {  // App request to disable SOS leaf
            Serial.println("Sending reply: " + value);
            BLE_Characteristics.writeValue(value);
          }
        }     
        // ***Chat page test**
        else {
          String reply = "...";
          Serial.println("Sending reply: " + reply);
          BLE_Characteristics.writeValue(reply);
        }
      }

      

    }
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }

} //end loop()


// When called, this helper function turns on lights in specified color for 2 seconds, then off for 2 seconds, 
// and repeats that on/off pattern for 30 seconds, and then exits the function
void flashPattern(long alpha, long red, long green, long blue) {
  static unsigned long previousMillis = 0;
  static unsigned long patternStartMillis = 0;
  const int patternDuration = 30000;  // 30 seconds
  const int flashDuration = 2000;  // 2 seconds
  static bool isFlashOn = false;
  unsigned long currentMillis = millis();

  // Check if the pattern has just started
  if (patternStartMillis == 0) {
    patternStartMillis = currentMillis;  // Update the pattern start time
  }
  // Continue flashing pattern for 30 seconds
  while (currentMillis - patternStartMillis < patternDuration) {
    // Check if it's time to toggle the flash state
    if (currentMillis - previousMillis >= flashDuration) {
      previousMillis = currentMillis;  // Save the current time
      isFlashOn = !isFlashOn;  // Toggle the flash pattern state
    }
    // Display Flash pattern (lights on) or !Flash pattern (lights off)
    for (int i = 0; i < NUMPIXELS; i++) {
      if (isFlashOn) {
        // Display Flash pattern (lights on)
        pixels.setPixelColor(i, pixels.Color(red * ((double)alpha / 255), green * ((double)alpha / 255), blue * ((double)alpha / 255)));
      } else {
        // Turn off all lights for Flash pattern (lights off)
        pixels.setPixelColor(i, pixels.Color(0, 0, 0));
      }
    }
    pixels.show();
    // Update currentMillis
    currentMillis = millis();
  }
  // Flash pattern complete, print message and reset patternStartMillis
  Serial.println("Flash pattern complete");
  patternStartMillis = 0;

}

