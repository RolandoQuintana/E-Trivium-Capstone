#include <ArduinoBLE.h>
#include <Adafruit_NeoPixel.h>
#include <Arduino_LSM9DS1.h>
#include <String.h>

// Built-in LED
const int ledPin = 13;  
// Popular NeoPixel ring size
#define NUMPIXELS 20
// pins on the Arduino connected to the NeoPixels
#define RPin1      10 // On Trinket or Gemma, suggest changing this to 1
#define RPin2      9
#define RPin3      11
#define RPin4      12
#define LPin1      8 // On Trinket or Gemma, suggest changing this to 1
#define LPin2      6
#define LPin3      7
#define LPin4      5

// When setting up the NeoPixel library, we tell it how many pixels,
// and which pin to use to send signals. Note that for older NeoPixel
// strips you might need to change the third parameter -- see the
// strandtest example for more information on possible values.
Adafruit_NeoPixel Right1(NUMPIXELS, RPin1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Right2(NUMPIXELS, RPin2, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Right3(NUMPIXELS, RPin3, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Right4(NUMPIXELS, RPin4, NEO_GRB + NEO_KHZ800);

Adafruit_NeoPixel Left1(NUMPIXELS, LPin1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Left2(NUMPIXELS, LPin2, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Left3(NUMPIXELS, LPin3, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel Left4(NUMPIXELS, LPin4, NEO_GRB + NEO_KHZ800);

BLEService BLE_Service("af565a71-01c0-4a19-829f-86ae5800efed");
BLEStringCharacteristic BLE_Characteristics("474d9179-b87b-42d8-b954-135be2fa94c6", BLERead | BLENotify | BLEWrite | BLEWriteWithoutResponse, 100);


void setup() {
  // Start serial for debugging
  Serial.begin(9600);

  // LED strip set up
  Right1.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  Right2.begin();
  Right3.begin();
  Right4.begin();
  Left1.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  Left2.begin();
  Left3.begin();
  Left4.begin();

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
  BLE.setLocalName("E-Triv-Arduino");
  BLE.setAdvertisedService(BLE_Service);
  BLE_Service.addCharacteristic(BLE_Characteristics);
  BLE.addService(BLE_Service);
  BLE.advertise();
  Serial.println("Bluetooth activated, waiting for a connection");

} //end setup() 


int lastBatteryPercentage = -1; // Initialize to a value that won't conflict with actual percentages
int battery_percentage = 0;
float x = 0;
float y = 0;
float z = 0;
unsigned long batteryCheckInterval = 3000;  // Check battery every 3 seconds
unsigned long lastBatteryCheckTime = 0;
String batStr;
int steps = 0;
int lastStepCount = 0;
int STEP_THRESHOLD = 2;  //**TODO** -- So far <2 constantly updates steps, >=2 doesn't record step changes..
float magnitude = 0;
String stepsStr = "";
bool appPostureEnabled = false;
int light_on = 1;


void loop() {  
  unsigned long currentMillis = millis();
  
  if (!BLE.connected()) {
    steps = 0;
    lastStepCount = 0;
  }


  /* ----- BLE Message Handling ----- */
  BLEDevice central = BLE.central();
  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    while (central.connected()) {
      // Handle BLE events (received messages) 
      BLE.poll();



      /* ----- Battery Monitoring ----- */
      // Reads pin for battery percentage, then sends that value to the app for users to see
      //int sensorValue = analogRead(A0);  // To run normally: uncomment this line and comment the below line
      int sensorValue = 860;  // To test: uncomment this line and comment the above line
      if (sensorValue >= 850) {
        battery_percentage = 100;          
      } 
      else if (sensorValue < 850 && sensorValue >= 770) {  //else if (sensorValue < 835 && sensorValue > 770)
        battery_percentage = 75;
      } 
      else if (sensorValue < 770 && sensorValue >= 730) {  //else if (sensorValue < 755 && sensorValue > 730)
        battery_percentage = 50;
      } 
      else if (sensorValue < 730 && sensorValue >= 665) {  //else if (sensorValue < 715 && sensorValue > 680)
        battery_percentage = 25;
      } 
      else if (sensorValue < 665) {
        battery_percentage = 0;
      }
      // Check if the battery percentage has changed since the last report to the app
      if (battery_percentage != lastBatteryPercentage) {
        // Send app new updated battery charge amount
        Serial.println("Sending battery charge: " + String(battery_percentage) + "%");
        batStr = "Battery" + String(battery_percentage);
        bool check = sendMsgToApp(batStr);  
        if (check == false) {
          Serial.println("Error sending battery charge!");
        }
        // Update the last reported battery percentage
        lastBatteryPercentage = battery_percentage;
      }


      String value = getValueFromApp();  // Use this received String value for basically everything
      // Note: Only get value from app once per loop, multiple calls won't work/breaks things!

      
      /* ----- LIGHT LEAF ----- */
      // Checks for color &/or pattern requests from the app and handles them
      if (value == "test") {  // ***Chat page test**
        String reply = "test test";  // Can change reply msg to app here
        bool check = sendMsgToApp(reply);  
        if (check == false) {
          Serial.println("Error sending test test!");
        }        
      }
      else if (value == "EnableLights") {  // App request to enable lights
        // **TODO** -- test enable lights!
        Serial.println("Enabling lights");
        //solidPattern(0, 0, 0, 0);  // Call function to turn on lights
        light_on = 1;  // Flag to show light leaf enabled
      } 
      else if (value == "DisableLights") {  // App request to disable lights (actually just turn them off)
        // **TODO** -- test disable lights!
        Serial.println("Disabling lights");
        solidPattern(0, 0, 0, 0);  // Call function to turn off lights
        light_on = 0;  // Flag to show light leaf disabled
      } 
      // App request to just change light leaf color
      else if ((value.length() == 8) && light_on) {
        // Acknowledge app request and sent hex color code back to the app
        Serial.println("Acknowledging change color request: " + value);
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending color change request!");
        } 
        // Extract value parts and convert them to ints
        int alpha = hexToInt(value.substring(0, 2));
        int red = hexToInt(value.substring(2, 4));
        int green = hexToInt(value.substring(4, 6));
        int blue = hexToInt(value.substring(6, 8));
        // Set pixels
        solidPattern(alpha, red, green, blue);
      }
      // App request to change light leaf color + pattern
      else if ((value.length() == 13) && light_on) {
        // Acknowledge app request and sent hex color code back to the app
        Serial.println("Acknowledging change color + pattern request: " + value);
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending color + pattern change acknowledgement!");
        } 
        // Extract value parts and convert them to ints
        int alpha = hexToInt(value.substring(0, 2));
        int red = hexToInt(value.substring(2, 4));
        int green = hexToInt(value.substring(4, 6));
        int blue = hexToInt(value.substring(6, 8));
        //Set pixels
        if (patternValue == "Solid") {
          Serial.println("Setting Solid light leaf pattern.");
          // Set pixels
          solidPattern(alpha, red, green, blue);  // Call Solid pattern function
        } 
        else if (patternValue == "Flash") {
          // **TODO** -- test flash light pattern!
          Serial.println("Setting Flash light leaf pattern.");  
          flashPattern(alpha, red, green, blue);  // Call Flash pattern function   
        } 
        else {
          Serial.println("Error light leaf disabled or unexpected request.");
        }
      }   


      
      /* ----- SOS LEAF ----- */
      // Tests that Arduino gets/responds to app SOS enable/disable
      //String appMsg = getValueFromApp();
      if (value == "EnableSOS") {  // App request to enable SOS leaf
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending SOS enable!");
        } 
      }
      else if (value == "DisableSOS") {  // App request to disable SOS leaf
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending SOS disable!");
        } 
      }
      // Arduino detects when SOS button has been pressed and sends "SOS" string to the app so app can SMS contacts
      //**TODO** -- adjust code to have sos button press detection
      //int sosButton = analogRead(A0);  // To run normally: uncomment this line and comment the below line
      int sosButton = 0;  // To test: uncomment this line and comment the above line
      if (sosButton != 0) {  // 0 = SOS button not pressed, !0 = SOS button pressed        
        bool check = sendMsgToApp("SOS");  
        if (check == false) {
          Serial.println("Error sending SOS msg!");
        }
        // This then checks that SOS text was sent from the app
        String sosReply = getValueFromApp();
        if (sosReply=="Sent SOS SMS!") {
          Serial.print("App sent SOS SMS!");
        }
      } 
   


      // Read accelerometer data for health leaf pedometer and posture 
      if (IMU.accelerationAvailable()) {  
        IMU.readAcceleration(y, x, z);
        //Serial.println("x = " + String(x) + ", y = " + String(y) + ", z = " + String(z));  // For testing
        magnitude = sqrt( (x*x) + (y*y) + (z*z));        
        delay(10);  // For testing
      }



      /* ----- HEALTH LEAF : PEDOMETER----- */   
       //THIS BREAKS MY CODE SO ARDUINO WONT SENT TEST TEST!!!
      //**TODO** -- Need to find better STEP_THRESHOLD since <2 constantly updates steps, >=2 doesn't record step changes..
      // Already got accelerometer data above
      // Check for a step
      if (magnitude > STEP_THRESHOLD) {  //**Adjust step threshold to a better value?
        steps++;
        //Serial.println("STEP COUNT: " + String(steps));  // For testing
        //delay(100);  // For testing
      }
      // Update BLE characteristic if step count changes  
      // Check for & handle reset step counter request
      //String resetStepsValue = getValueFromApp();
      if (value == "ResetSteps") {
        Serial.println("Reset step counter");
        lastStepCount = 0;
        steps = 0;
        stepsStr = "Step" + String(steps);
        bool check = sendMsgToApp(stepsStr);  
        if (check == false) {
          Serial.println("Error sending reset step count!");
        }
      }            
      else {  // Update steps and send steps count
        if (steps != lastStepCount) {
          stepsStr = "Step" + String(steps);
          Serial.println("Sending step: " + String(steps));          
          bool check = sendMsgToApp(stepsStr);  
          if (check == false) {
            Serial.println("Error sending step count!");
          }
          lastStepCount = steps;       
        }       
        //delay(100);  // For testing
      }
      


      /* ----- HEALTH LEAF : POSTURE ----- */
      if (value == "EnablePosture") {  // App request to enable posture alerts
        appPostureEnabled = true;  // Set posture flag
        Serial.println("App posture enabled.");
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending posture enabled!");
        }
      }
      else if (value == "DisablePosture") {  // App request to disable posture alerts
        appPostureEnabled = false;  // Reset posture flag
        Serial.println("App posture disable.");
        bool check = sendMsgToApp(value);  
        if (check == false) {
          Serial.println("Error sending posture disabled!");
        }
      }
      if (appPostureEnabled) {
        // Already got accelerometer data above
        if (y < 0.9 && y > -0.9) {  //**Double check that this is right for posture check?
          // Tell app user has bad posture
          // Side note-- Unable to do app push notifications without upgrading app plan.. 
          // ..app will use snack bar notification instead
          String msg = "BadPosture";  
          Serial.println("Sending bad posture alert!");
          bool check = sendMsgToApp(msg);  
          if (check == false) {
            Serial.println("Error sending posture enabled!");
          }
          delay(100);
        } 
        else {  // User's posture is okay for now
          String msg = "PostureOK";
          //Serial.println("Posture okay.");
          //BLE_Characteristics.writeValue(msg);
          delay(100);
        }
      }     

      
    }
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }

} //end loop()



// Helper function that gets/returns received String value from the app
String getValueFromApp () {
  if (BLE_Characteristics.written()) {
    String value = BLE_Characteristics.value();
    Serial.println("Received value: " + value); 
    return value;
  }
  else {
    return "";
  }
}


// Helper function that sends String message to the app
bool sendMsgToApp (String msg) {
  if (msg != "") {
    Serial.println("Sending msg: " + msg);
    BLE_Characteristics.writeValue(msg);
    return true;
  }
  else {
    return false;
  }
}


// Converts String hex values into longs then into ints then returns the ints
int hexToInt(String hex) {
  long long_value = strtol(hex.c_str(), NULL, 16);
  return (int)long_value;
}


// Sets solid light leaf pattern + colors 
void solidPattern(int alpha, int red, int green, int blue) {
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);
  // Set each pixel
  for(int i=0; i<NUMPIXELS; i++) { // For each pixel...
    Right1.setPixelColor(i, Right1.Color(r, g, b));
    Right1.show();   // Send the updated pixel colors to the hardware
    Right2.setPixelColor(i, Right1.Color(r, g, b));
    Right2.show();   // Send the updated pixel colors to the hardware
    Right3.setPixelColor(i, Right1.Color(r, g, b));
    Right3.show();   // Send the updated pixel colors to the hardware
    Right3.setPixelColor(i, Right1.Color(r, g, b));
    Right3.show();   // Send the updated pixel colors to the hardware
    Right4.setPixelColor(i, Right1.Color(r, g, b));
    Right4.show();   // Send the updated pixel colors to the hardware
    Left1.setPixelColor(i, Right1.Color(r, g, b));
    Left1.show();   // Send the updated pixel colors to the hardware;
    Left2.setPixelColor(i, Right1.Color(r, g, b));
    Left2.show();   // Send the updated pixel colors to the hardware;
    Left3.setPixelColor(i, Right1.Color(r, g, b));
    Left3.show();   // Send the updated pixel colors to the hardware;
    Left4.setPixelColor(i, Right1.Color(r, g, b));
    Left4.show();   // Send the updated pixel colors to the hardware;  
  }
}


// When called, this helper function turns on lights in specified color for 2 seconds, then off for 2 seconds, 
// and repeats that on/off pattern for 30 seconds, and then exits the function
void flashPattern(int alpha, int red, int green, int blue) {
  static unsigned long previousMillis = 0;
  static unsigned long patternStartMillis = 0;
  const int patternDuration = 30000;  // 30 seconds
  const int flashDuration = 2000;  // 2 seconds
  static bool isFlashOn = false;
  unsigned long currentMillis = millis();
  // Set int color values
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);

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
        Right1.setPixelColor(i, Right1.Color(r, g, b));
        Right1.show();   // Send the updated pixel colors to the hardware
        Right2.setPixelColor(i, Right2.Color(r, g, b));
        Right2.show();   // Send the updated pixel colors to the hardware
        Right3.setPixelColor(i, Right3.Color(r, g, b));
        Right3.show();   // Send the updated pixel colors to the hardware
        Right4.setPixelColor(i, Right4.Color(r, g, b));
        Right4.show();   // Send the updated pixel colors to the hardware
        Left1.setPixelColor(i, Left1.Color(r, g, b));
        Left1.show();   // Send the updated pixel colors to the hardware;
        Left2.setPixelColor(i, Left2.Color(r, g, b));
        Left2.show();   // Send the updated pixel colors to the hardware;
        Left3.setPixelColor(i, Left3.Color(r, g, b));
        Left3.show();   // Send the updated pixel colors to the hardware;
        Left4.setPixelColor(i, Left4.Color(r, g, b));
        Left4.show();   // Send the updated pixel colors to the hardware;  
      } 
      else {
        // Turn off all lights for Flash pattern (lights off)
        Right1.setPixelColor(i, Right1.Color(0, 0, 0));
        Right1.show();   // Send the updated pixel colors to the hardware
        Right2.setPixelColor(i, Right2.Color(0, 0, 0));
        Right2.show();   // Send the updated pixel colors to the hardware
        Right3.setPixelColor(i, Right3.Color(0, 0, 0));
        Right3.show();   // Send the updated pixel colors to the hardware
        Right4.setPixelColor(i, Right4.Color(0, 0, 0));
        Right4.show();   // Send the updated pixel colors to the hardware
        Left1.setPixelColor(i, Left1.Color(0, 0, 0));
        Left1.show();   // Send the updated pixel colors to the hardware;
        Left2.setPixelColor(i, Left2.Color(0, 0, 0));
        Left2.show();   // Send the updated pixel colors to the hardware;
        Left3.setPixelColor(i, Left3.Color(0, 0, 0));
        Left3.show();   // Send the updated pixel colors to the hardware;
        Left4.setPixelColor(i, Left4.Color(0, 0, 0));
        Left4.show();   // Send the updated pixel colors to the hardware;
      }
    }
    // Update currentMillis
    currentMillis = millis();
  }
  // Flash pattern complete, print message and reset patternStartMillis
  Serial.println("Flash pattern complete");
  patternStartMillis = 0;
}

