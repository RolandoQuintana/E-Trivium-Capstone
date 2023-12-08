#include <ArduinoBLE.h>
#include <Adafruit_NeoPixel.h>
#include <Arduino_LSM9DS1.h>
#include <String.h>

// Built-in LED
const int ledPin = 13; 
// Popular NeoPixel ring size
#define NUMPIXELS 20
// Pins on the Arduino connected to the NeoPixels
#define RPin1      10 // On Trinket or Gemma, suggest changing this to 1
#define RPin2      9
#define RPin3      11
#define RPin4      12
#define LPin1      8 // On Trinket or Gemma, suggest changing this to 1
#define LPin2      6
#define LPin3      7
#define LPin4      5

// functions definitions
int  hexToInt(String hex);
void solidLED (int red, int green, int blue, int alpha);
void rainLED2 (int red, int green, int blue, int alpha);
void rainLED (int red, int green, int blue, int alpha);
void randomLED (int red, int green, int blue, int alpha);

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
BLEStringCharacteristic BLE_Characteristics("474d9179-b87b-42d8-b954-135be2fa94c6", BLERead | BLENotify | BLEWrite, 100);


void setup() {
  // Start serial
  Serial.begin(9600);

  // Led strip set up
  Right1.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  Right2.begin();
  Right3.begin();
  Right4.begin();
  Left1.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  Left2.begin();
  Left3.begin();
  Left4.begin();

  // Initialize built in LED
  pinMode(ledPin, OUTPUT);

  // IMU code for posture monitoring
  if (!IMU.begin()) {
    Serial.println("failed to initialize IMU");
    // while (1); // for debugging
  }

  BLE.begin();
  BLE.setLocalName("E-Triv-Ard");
  BLE.setAdvertisedService(BLE_Service);
  BLE_Service.addCharacteristic(BLE_Characteristics);
  BLE.addService(BLE_Service);
  BLE.advertise();

  solidLED(0, 0, 0, 0);
}


int posture_counter = 0;
float x, y, z;
int SOS_enable = 0;
int posture_enable = 0;
int light_on = 1;
int posture_LED_on = 0;
double posture_sensitivity = 0.9;
double step_sensitivity = 0.9;
int flash_on = 0;
int flash_counter = 999;
int breathe_on = 0;
int breathe_counter = 0;
int breathe = -5;
int rain_drop = -30;
int rain_drop_on = 0;
int rain_drop_counter = 0;
int random_LED_on = 0;
int random_LED_counter = 0;
int pattern = 0;
int alpha = 0;
int red = 0;
int green = 0;
int blue = 0;
int step_count = 0;
int step_delay = 0;
int x_old = 0;
int button_pressed = 0;
int lastBatteryPercentage = -1; // Initialize to a value that won't conflict with actual percentages
int battery_percentage = 0;
unsigned long batteryCheckInterval = 3000;  // Check battery every 3 seconds
unsigned long lastBatteryCheckTime = 0;
int steps = 0;
int lastStepCount = 0;
int STEP_THRESHOLD = 2;  //**TODO** -- So far <2 constantly updates steps, >=2 doesn't record step changes..
float magnitude = 0;


void loop() {
  // Handle BLE events (send messages) 

  if (!BLE.connected()) {  //Clear step count if BLE disconnects
    steps = 0;
    lastStepCount = 0;
  }


  // Posture monitoring code:
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(y, x, z);
    //Serial.println("x = " + String(x) + ", y = " + String(y) + ", z = " + String(z));  // For testing
    magnitude = sqrt( (x*x) + (y*y) + (z*z));        
    delay(10);  // For testing
    //if(step_delay == 0) {
    //  x_old = x;
    //}
  }

  // Posture code:
  if (x < posture_sensitivity && x > -posture_sensitivity && posture_enable) {
    posture_counter++; // if person posture is bad start counting before alerting
    if (posture_LED_on && posture_counter == 500) {
      solidLED(255, 255, 0, 255);
    }
    if (posture_counter == 2500) { // after approx. few seconds alert user (we can change time later)
      BLE_Characteristics.writeValue("BadPosture");
      if (posture_LED_on) {solidLED(255, 0, 0, 255);}
      digitalWrite(ledPin, HIGH); // for debugging
    }
  } 
  else {
    digitalWrite(ledPin, LOW);// for debugging
    if (posture_LED_on && posture_enable) {
      solidLED(red, green, blue, alpha);
    }
    posture_counter = 0;
  }

  // Pedometer code:
  // if (step_delay > 200) {
  //   if(abs(x - x_old) < 0.1) {
  //     step_count++;
  //     step_delay = 0;
  //     BLE_Characteristics.writeValue("Step" + String(step_count));
  //   }
  // }
  // if (step_delay < 201) {
  //   step_delay++;
  // }  
  if (magnitude > STEP_THRESHOLD) {  //**Adjust step threshold to a better value
    steps++;
    //Serial.println("STEP COUNT: " + String(steps));  // For testing
  }
  if (steps != lastStepCount) {
    BLE_Characteristics.writeValue("Step" + String(steps));
    lastStepCount = steps;       
  }  

  // Serial.println(x);

  // Battery monitoring code:
  // Reads pin for battery percentage, then sends that value to the app for users to see
  int sensorValue = analogRead(A0);  // To run normally: uncomment this line and comment the below line
  int offset = 30;
    // int sensorValue = 860;  // To test: uncomment this line and comment the above line
  if (sensorValue > 850 + offset) {
    battery_percentage = 100;
  } 
  else if (sensorValue < 835 + offset && sensorValue > 770 + offset) {
    battery_percentage = 75;
  } 
  else if (sensorValue < 755 + offset && sensorValue > 730 + offset) {
    battery_percentage = 50;
  } 
  else if (sensorValue < 715 + offset && sensorValue > 660 + offset) {
    battery_percentage = 25;
  } 
  else if (sensorValue < 635 + offset) {
    battery_percentage = 0;
  }
  // Check if the battery percentage has changed since the last report to the app
  if (battery_percentage != lastBatteryPercentage) {
    // Send app new updated battery charge amount
    BLE_Characteristics.writeValue("Battery" + String(battery_percentage) + "%");
    // Update the last reported battery percentage
    lastBatteryPercentage = battery_percentage;
  }

  // SOS code (with button):
  // SOS button handle (we didn't add SOS button yet)
  // if SOS was enabled sent the SOS message then disable.
  // if (SOS_enable && button_pressed) {
  //   BLE_Characteristics.writeValue("SOS");
  //   button_pressed = 0;
  // }
  
  // Handle BLE events (received messages) 
  BLE.poll();

  if (BLE_Characteristics.written()) {
    String value = BLE_Characteristics.value();
    Serial.print("Received value: "); // for debugging 
    Serial.println(value); // for debugging      

    // SOS code (without button):
    // If SOS enabled and receive "TestSOS" from app, act as if SOS button was pressed
    if (SOS_enable && value=="TestSOS") {
      BLE_Characteristics.writeValue("SOS");
    }

    // Light leaf code:
    // handle change LED requests
    if (!light_on) {
      BLE_Characteristics.writeValue("Light leaf is off. Please turn it on");
    }

    if (value.startsWith("Pattern") && light_on) {
      pattern = value.substring(7, 8).toInt();
      alpha = hexToInt(value.substring(8, 10));
      red = hexToInt(value.substring(10, 12));
      green = hexToInt(value.substring(12, 14));
      blue = hexToInt(value.substring(14, 16));
      flash_on = 0;
      breathe_on = 0;
      rain_drop_on = 0;
      posture_LED_on = 0;
      random_LED_on = 0;
      solidLED(0, 0, 0, 0);
      if (pattern == 1) {
        BLE_Characteristics.writeValue("solid pattern");
        solidLED(red, green, blue, alpha);
      } 
      else if (pattern == 2) {
        BLE_Characteristics.writeValue("flash pattern");
        flash_on = 1;
      } 
      else if (pattern == 3) {
        BLE_Characteristics.writeValue("breathe pattern");
        breathe_on = 1;
      } 
      else if (pattern == 4) {
        BLE_Characteristics.writeValue("rain drop pattern");
        rain_drop_on = 1;
      } 
      else if (pattern == 5) {
        if(posture_enable) {
        BLE_Characteristics.writeValue("postrue led pattern");
        } else {
          BLE_Characteristics.writeValue("please enable posture from health menu to see LED");
        }
        posture_LED_on = 1;
      }
      else if (pattern == 6) {
        BLE_Characteristics.writeValue("random led pattern");
        random_LED_on = 1;
      }
    }

    // handle enable LED requests
    if (value.startsWith("Lights")) {
      light_on = value.substring(6, 7).toInt();
      // light_on = light_leaf_value;``
      if(!light_on) {
        solidLED(0, 0, 0, 0);
        flash_on = 0;
        breathe_on = 0;
        rain_drop_on = 0;
        posture_LED_on = 0;
        random_LED_on = 0;
        BLE_Characteristics.writeValue("lights disabled");
      } 
      else {
        BLE_Characteristics.writeValue("lights enabled");
      }
    }

    // Health leaf:
    // handle SOS request
    if (value.startsWith("SOS")) {
      SOS_enable = value.substring(3, 4).toInt();
      if (SOS_enable) {
        BLE_Characteristics.writeValue("SOS enabled");
      } 
      else {
        BLE_Characteristics.writeValue("SOS disabled");
      }
    }

    // handle posture request
    if (value.startsWith("Posture")) {
      posture_enable = value.substring(7, 8).toInt();
      if (posture_enable) {
        BLE_Characteristics.writeValue("posture detection enabled");
      } 
      else {
        BLE_Characteristics.writeValue("posture detection disabled");
      }
    }
    if (value.startsWith("ResetSteps")) {
      step_count = 0;
    }
    if (value.startsWith("Button1")) {
      button_pressed = 1;
    }

    // for debugging
    if (value.startsWith("sposture")) {
      posture_sensitivity = value.substring(8, 11).toDouble();
      Serial.println(posture_sensitivity);
    }
  }   

  // change LED pattern:
  if (flash_on) {
    flash_counter++;
    if (flash_counter == 1000) {
      solidLED(red, green, blue, alpha);
    } 
    else if (flash_counter == 2000) {
      flash_counter = 0;
      solidLED(0, 0, 0, 0);
    }
  }

  if (breathe_on) {
    breathe_counter++;
    if (breathe_counter == 30) {
      solidLED(red, green, blue, alpha);
      if (alpha + breathe <= 25) {
        breathe = 5;
      } 
      if (alpha + breathe >= 180) {
        breathe = -5;
      } 
      alpha = alpha + breathe;
      breathe_counter = 0;
    }
  }

  if (rain_drop_on) {
    rain_drop_counter++;
    if (rain_drop_counter == 50) {
      rainLED(red, green, blue, alpha);
    }
    if (rain_drop_counter == 150) {
      // solidLED2(0, 0, 0, 0);
      rainLED2(red, green, blue, 10);
      rain_drop_counter = 0;
    }
  }
  
  if (random_LED_on) {
    random_LED_counter++;
    if (random_LED_counter == 350) {
      randomLED(red, green, blue, alpha);
      random_LED_counter = 0;
    }
  }

}


// helper functions
int hexToInt(String hex) {
  long long_value = strtol(hex.c_str(), NULL, 16);
  return (int) long_value;
}


void solidLED (int red, int green, int blue, int alpha) {
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);

  for (int i=0; i<NUMPIXELS; i++) { // For each pixel...
    Right1.setPixelColor(i, Right1.Color(r, g, b));
    Right2.setPixelColor(i, Right2.Color(r, g, b));
    Right3.setPixelColor(i, Right3.Color(r, g, b));
    Right4.setPixelColor(i, Right4.Color(r, g, b));
    Left1.setPixelColor(i, Left1.Color(r, g, b));
    Left2.setPixelColor(i, Left2.Color(r, g, b));
    Left3.setPixelColor(i, Left3.Color(r, g, b));
    Left4.setPixelColor(i, Left4.Color(r, g, b));
  }

  Right1.show();   // Send the updated pixel colors to the hardware
  Right2.show();   // Send the updated pixel colors to the hardware
  Right3.show();   // Send the updated pixel colors to the hardware
  Right3.show();   // Send the updated pixel colors to the hardware
  Right4.show();   // Send the updated pixel colors to the hardware
  Left1.show();   // Send the updated pixel colors to the hardware;
  Left2.show();   // Send the updated pixel colors to the hardware;
  Left3.show();   // Send the updated pixel colors to the hardware;
  Left4.show();   // Send the updated pixel colors to the hardware;  
}

void rainLED (int red, int green, int blue, int alpha) {
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);
  double alpha1 = ((double)150/255);
  double alpha2 = ((double)100/255);
  double alpha3 = ((double)50/255);
  double alpha4 = ((double)20/255);

  for (int i=0; i<NUMPIXELS; i++) { // For each pixel...
    Right1.setPixelColor(i, Right1.Color(red * alpha1, green * alpha1, blue * alpha1));
    Right1.show();   // Send the updated pixel colors to the hardware
    Right2.setPixelColor(i, Right1.Color(red * alpha2, green * alpha2, blue * alpha2));
    Right2.show();   // Send the updated pixel colors to the hardware
    Right3.setPixelColor(i, Right1.Color(red * alpha3, green * alpha3, blue * alpha3));
    Right3.show();   // Send the updated pixel colors to the hardware
    Right4.setPixelColor(i, Right1.Color(red * alpha4, green * alpha4, blue * alpha4));
    Right4.show();   // Send the updated pixel colors to the hardware

    Left1.setPixelColor(i, Right1.Color(red * alpha1, green * alpha1, blue * alpha1));
    Left1.show();   // Send the updated pixel colors to the hardware;
    Left2.setPixelColor(i, Right1.Color(red * alpha2, green * alpha2, blue * alpha2));
    Left2.show();   // Send the updated pixel colors to the hardware;
    Left3.setPixelColor(i, Right1.Color(red * alpha3, green * alpha3, blue * alpha3));
    Left3.show();   // Send the updated pixel colors to the hardware;
    Left4.setPixelColor(i, Right1.Color(red * alpha4, green * alpha4, blue * alpha4));
    Left4.show();   // Send the updated pixel colors to the hardware;  
  }
}

void rainLED2 (int red, int green, int blue, int alpha) {
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);

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

void randomLED (int red, int green, int blue, int alpha) {
  int r = red * ((double)alpha/255);
  int g = green * ((double)alpha/255);
  int b = blue * ((double)alpha/255);

  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Right1.setPixelColor(i, Right1.Color(randomVar1, randomVar2, randomVar3));
    Right1.setPixelColor(i + 1, Right1.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Right2.setPixelColor(i, Right2.Color(randomVar1, randomVar2, randomVar3));
    Right2.setPixelColor(i + 1, Right2.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Right3.setPixelColor(i, Right3.Color(randomVar1, randomVar2, randomVar3));
    Right3.setPixelColor(i + 1, Right3.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Right4.setPixelColor(i, Right4.Color(randomVar1, randomVar2, randomVar3));
    Right4.setPixelColor(i + 1, Right4.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Left1.setPixelColor(i, Left1.Color(randomVar1, randomVar2, randomVar3));
    Left1.setPixelColor(i + 1, Left1.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Left2.setPixelColor(i, Left2.Color(randomVar1, randomVar2, randomVar3));
    Left2.setPixelColor(i + 1, Left2.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Left3.setPixelColor(i, Left3.Color(randomVar1, randomVar2, randomVar3));
    Left3.setPixelColor(i + 1, Left3.Color(randomVar1, randomVar2, randomVar3));
  }
  for(int i=0; i<NUMPIXELS; i+=2) { // For each pixel...
    int randomVar1 = random(10, 241);
    int randomVar2 = random(10, 241);
    int randomVar3 = random(10, 241);
    Left4.setPixelColor(i, Left4.Color(randomVar1, randomVar2, randomVar3));
    Left4.setPixelColor(i + 1, Left4.Color(randomVar1, randomVar2, randomVar3));
  }

  Right1.show();   // Send the updated pixel colors to the hardware
  Right2.show();   // Send the updated pixel colors to the hardware
  Right3.show();   // Send the updated pixel colors to the hardware
  Right3.show();   // Send the updated pixel colors to the hardware
  Right4.show();   // Send the updated pixel colors to the hardware
  Left1.show();   // Send the updated pixel colors to the hardware;
  Left2.show();   // Send the updated pixel colors to the hardware;
  Left3.show();   // Send the updated pixel colors to the hardware;
  Left4.show();   // Send the updated pixel colors to the hardware; 
}
