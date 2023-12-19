#include <AccelStepper.h>
#include <ezButton.h>
#include <Wire.h>
#include <SparkFun_APDS9960.h>

#include <ArduinoBLE.h>
#include <String.h>

#define APDS9960_INT    2 // Needs to be an interrupt pin

BLEService BLE_Service_Wardrobe("1101");
BLEStringCharacteristic wardrobeChar("2101", BLERead | BLENotify | BLEWrite, 100);
BLEDevice central;
int firstConnect = 1;

int myHeight = 3000;
int warHeight = 0;
int liftOff = -1000;

int state_prev_st = 0;
int state_st = 0;

int state_prev_bot = 0;
int state_bot = 0;

int state_prev_top = 0;
int state_top = 0;

unsigned long bottomTime_0 = 0;
int bottomLimit = 7000;

unsigned long topTime_0 = 0;
int topLimit = 2000;
int topForwardMAX = 100;
int topBackwardMAX = 100;
float topCurrSpeed = 0;
float topLastSpeed = 0;

float accel = .05;
float deAccelForward = .07;
float deAccelBackward = .01;

const int bottomEN = 6;
const int bottomIn1 = 8;
const int bottomIn2 = 7;

const int topEN = 5;
const int topIn1 = 4;
const int topIn2 = 9;

const int pulseRight = 13;
const int dirRight = 12;
const int pulseLeft = 11;
const int dirLeft = 10;

const int limitSwitchPin = 2;
const int nxtButtonPin = 3;

const int IRpin = A0;

ezButton limitSwitch(limitSwitchPin);
ezButton nxtButton(nxtButtonPin);


bool limitReached = false;

AccelStepper stepperRight(AccelStepper::DRIVER, pulseRight, dirRight); // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5
AccelStepper stepperLeft(AccelStepper::DRIVER, pulseLeft, dirLeft); // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5

SparkFun_APDS9960 apds = SparkFun_APDS9960();

enum dir {
  up,
  down,
  left,
  right,
  near,
  far,
  none
};


void setup() {
  Serial.begin(9600);
  //while(!Serial);

  //////////////////////////////////////////////////////
  /////////////Button Setup////////////////////////////
  limitSwitch.setDebounceTime(50);
  nxtButton.setDebounceTime(50);
  /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  //////////////////////////////////////////////////////
  /////////////Stepper Setup////////////////////////////
   stepperRight.setMaxSpeed(2000.0);
   //stepperRight.setSpeed(1000.0);
   stepperRight.setAcceleration(2000.0);
   stepperLeft.setMaxSpeed(2000.0);
   stepperLeft.setAcceleration(2000.0);
  /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  //////////////////////////////////////////////////////
  /////////////Ln298 Setup////////////////////////////
  pinMode(bottomEN, OUTPUT);
  pinMode(bottomIn1, OUTPUT);
  pinMode(bottomIn2, OUTPUT);

  pinMode(topEN, OUTPUT);
  pinMode(topIn1, OUTPUT);
  pinMode(topIn2, OUTPUT);

  // Set initial rotation direction
  digitalWrite(bottomIn1, LOW);
  digitalWrite(bottomIn2, HIGH);

  digitalWrite(topIn1, HIGH);
  digitalWrite(topIn2, LOW);
  /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  ///////IR SENSOR//////
  pinMode(IRpin, INPUT);
  //////////////////////

  //////////////////////////////////////////////////////
  /////////////APDS Setup////////////////////////////
  // Initialize APDS-9960 (configure I2C and initial values)
  if ( apds.init() ) {
    Serial.println(F("APDS-9960 initialization complete"));
  } else {
    Serial.println(F("Something went wrong during APDS-9960 init!"));
  }
  
  // Start running the APDS-9960 gesture sensor engine
  if ( apds.enableGestureSensor(true) ) {
    Serial.println(F("Gesture sensor is now running"));
  } else {
    Serial.println(F("Something went wrong during gesture sensor init!"));
  }
  /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  //////////////////////////////////////////////////////
  /////////////BLE Setup///////////////////////////////
  pinMode(LED_BUILTIN, OUTPUT);
  if (!BLE.begin()) 
  {
  Serial.println("starting BLE failed!");
  while (1);
  }

  BLE.setLocalName("E-Triv-Wardrobe");
  BLE.setAdvertisedService(BLE_Service_Wardrobe);
  BLE_Service_Wardrobe.addCharacteristic(wardrobeChar);
  BLE.addService(BLE_Service_Wardrobe);

  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
  /////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  
  //Initial Stepper Sequence
   stepperRight.move(200);
   stepperLeft.move(-200);
   while(stepperRight.distanceToGo() > 0) {
    stepperRight.run();
    stepperLeft.run();
   }
  stepperRight.move(-200);
   stepperLeft.move(200);
   while(stepperRight.distanceToGo() > 0) {
    stepperRight.run();
    stepperLeft.run();
   }
   

}

void loop() {

  //Update EZ buttons
  limitSwitch.loop();
  nxtButton.loop();

  //Run State Machines
  SM_st();
  SM_bot();
  SM_top();

  //Update Steppers
  stepperRight.run();
  stepperLeft.run();

  //BLE
  BLEheight();






/////Stepper SM debug///////////
  if(state_st != state_prev_st) {
    Serial.print("Current Stepper State: ");
    Serial.println(state_st);
  }

/////Top SM debug///////////
  if(state_top != state_prev_top) {
    Serial.print("Current Top State: ");
    Serial.println(state_top);
  }

  /////Bot SM debug///////////
  if(state_bot != state_prev_bot) {
    Serial.print("Current Bot State: ");
    Serial.println(state_bot);
  }


  // if(topCurrSpeed != topLastSpeed) {
  //   Serial.print("Current Speed: ");
  //   Serial.println(topCurrSpeed);
  //   Serial.print("     Last Speed: ");
  //   Serial.println(topLastSpeed);
  // }
  

}

void SM_top() {
  state_prev_top = state_top;

  switch(state_top) {
    case 0: //Reset
      state_top = 1;
      digitalWrite(topIn1, HIGH);
      digitalWrite(topIn2, LOW);
      analogWrite(topEN, 0);
      topCurrSpeed = 0;
      topLastSpeed = 0;
      break;
    case 1: //Start
      if(state_st == 3) {state_top = 2;}
      break;
    case 2: //GO
      topTime_0 = millis();
      state_top = 3;
      break;
    case 3: //Move
      if((millis() - topTime_0) > topLimit) {
        if(!digitalRead(IRpin)) {
          state_top = 4;
          Serial.println(topCurrSpeed);
        }
      }
        accelDC(20, topForwardMAX, accel);
        analogWrite(topEN, topCurrSpeed);
      break;
    case 4: //Slow Down
        if(topCurrSpeed > 0) {
            accelDC(topForwardMAX, 0, deAccelForward);
            analogWrite(topEN, topCurrSpeed);
          }
          else {
            topLastSpeed = 0;
            state_top = 5;
          }
    break;
    case 5: //START GO!
    if(state_st == 9) {
      if(nxtButton.isReleased() || handleGesture() == far) {
        //if(handleGesture() == left) {state_st = 10;}
        topTime_0 = millis();
        digitalWrite(topIn1, LOW);
        digitalWrite(topIn2, HIGH);
        //analogWrite(topEN, 133);
        state_top = 6;
      }
    }
    break;
    case 6: //GOING
    if((millis() - topTime_0) > topLimit) {
      if(!digitalRead(IRpin)) {
        state_top = 7;
      }
    }
        accelDC(20, topBackwardMAX, accel);
        analogWrite(topEN, topCurrSpeed);
    break;
    case 7: //SLOW DOWN & RESET
      if(topCurrSpeed > 0) {
        accelDC(topBackwardMAX, 0, deAccelBackward);
        analogWrite(topEN, topCurrSpeed);
      }
      else {
        state_top = 0;
      }
    break;
  }
}

void SM_bot() {
  state_prev_bot = state_bot;

  switch(state_bot) {
    case 0: //Reset
      state_bot = 1;
      analogWrite(bottomEN, 0);
      break;
    case 1: //Start
      if(state_st == 2) {state_bot = 2; analogWrite(bottomEN, 255);}
      break;
    case 2: //GO
      bottomTime_0 = millis();
      state_bot = 3;
      break;
    case 3: //Wait & stop
      if((millis() - bottomTime_0) > bottomLimit) {
        state_bot = 0;
      }
      break;
  }
}

void SM_st() {
  state_prev_st = state_st;

  switch(state_st) {
    case 0: //Reset
      state_st = 1;
      break;
    case 1: //StartIDLE
      if(nxtButton.isReleased()) {state_st = 2;}
      if(handleGesture() == right) {state_st = 2;}
      break;
    case 2: //MoveHome
      stepperRight.move(-10000000);
      stepperLeft.move(10000000);
      state_st = 3;
      break;
    case 3: //Wait for Limit
      if(limitSwitch.isPressed()) {
        //stepperRight.setAcceleration(10000); stepperLeft.setAcceleration(10000);
        //stepperRight.move(0); stepperLeft.move(0); 
        stepperRight.setAcceleration(0); stepperLeft.setAcceleration(0);
        stepperRight.setSpeed(0); stepperLeft.setSpeed(0);
        stepperRight.runSpeed(); stepperRight.runSpeed();
        //stepperRight.move(0); stepperLeft.move(0); 
        state_st = 4;}
        // else {
        // stepperRight.setSpeed(5000); stepperLeft.setSpeed(5000);
        // stepperRight.runSpeed(); stepperRight.runSpeed();
        // }
      break;
    case 4: //Move to height
    stepperRight.setAcceleration(2000); stepperLeft.setAcceleration(2000);
    stepperRight.setMaxSpeed(2000); stepperLeft.setMaxSpeed(2000);
      stepperRight.move(myHeight);
      stepperLeft.move(-myHeight);
      state_st = 5;
      break;
    case 5: //Wait for height
      if(stepperRight.distanceToGo() == 0) {stepperRight.move(0); stepperLeft.move(0); state_st = 6;}
      break;
    case 6: //idle for lift off
      if(nxtButton.isReleased()) {state_st = 7;}
      if(handleGesture() == left) {state_st = 7;}
      break;
    case 7: //Lift off
      stepperRight.move(liftOff);
      stepperLeft.move(-liftOff);
      state_st = 8;
      break;
    case 8: //Wait for Lift off
      if(stepperRight.distanceToGo() == 0) {state_st = 9; stepperRight.move(0); stepperLeft.move(0);}
      break;
    case 9: //Idle for Top
      if(state_top == 1) {state_st = 0;}
    break;
  }
}

void accelDC(float start, float end, float inc) {
  topLastSpeed = topCurrSpeed;
  if(topLastSpeed < 0) {topLastSpeed = 0;}
  //if(topCurrSpeed == 0) {topLastSpeed = 0;}
  if((end - start) > 0) {
    if(topCurrSpeed < end) {
      topCurrSpeed += inc;
    }
    else {topCurrSpeed = end; topLastSpeed = end;}
  }
  else {
    if(topCurrSpeed > end) {
      topCurrSpeed -= inc;
    }
    else {topCurrSpeed = end; topLastSpeed = end;}
  }

}

dir handleGesture() {
    if ( apds.isGestureAvailable() ) {
    switch ( apds.readGesture() ) {
      case DIR_UP:
        Serial.println("UP");
        return up;
        break;
      case DIR_DOWN:
        Serial.println("DOWN");
        return down;
        break;
      case DIR_LEFT:
        Serial.println("LEFT");
        return left;
        break;
      case DIR_RIGHT:
        Serial.println("RIGHT");
        return right;
        break;
      case DIR_NEAR:
        Serial.println("NEAR");
        return near;
        break;
      case DIR_FAR:
        Serial.println("FAR");
        return far;
        break;
      default:
        Serial.println("NONE");
        return none;
    }
  }
  return none;
}

void BLEheight() {
  if(!central) {central = BLE.central(); firstConnect = 1;} //check if connected
  else {
    if(firstConnect) {Serial.print("Connected to central: "); Serial.println(central.address()); firstConnect = 0;}
    BLE.poll();
    if (wardrobeChar.written()) {
      String value = wardrobeChar.value();
      Serial.print("Received value: "); // for debugging 
      Serial.println(value); // for debugging 
    
      if (value == "adjustHeight" && state_st == 1) {
        Serial.print("Adjusting Height");
        wardrobeChar.writeValue("adjustStatustrue");
        adjusting();
      }
    }
  }
}

void adjusting() {
  int height = 0;
  homeSteppers();
  goToMyHeight();
  while (wardrobeChar.value() != "confirmHeight") {
    //Serial.println("adjusting");
  BLE.poll();
    if (wardrobeChar.written()) {
      String value = wardrobeChar.value();
      Serial.print("Received value: "); // for debugging 
      Serial.println(value); // for debugging 

      // handle slide requests
      if (value.startsWith("slide")) {
        Serial.println("in Slide");
        height =  value.substring(5).toInt();
        Serial.println(height);
        if(height > 5.0) {
          Serial.println("in adjust");
          stepperRight.moveTo(height);
          stepperLeft.moveTo(-height);
          //Serial.println(stepperRight.distanceToGo());
          while(stepperRight.currentPosition() != height) {
            //Serial.println("in motor move");
            stepperRight.run();
            stepperLeft.run();
          }
          Serial.print("Current Pos: ");
          Serial.println(stepperRight.currentPosition());
        }
      }
  
    }
  }
  wardrobeChar.writeValue(String(height));
  myHeight = height;
}

void homeSteppers() {
  stepperRight.move(-10000000);
  stepperLeft.move(10000000);
  while(!limitSwitch.isPressed()) {
    limitSwitch.loop();
    stepperRight.run();
    stepperLeft.run();
  }
  stepperRight.setAcceleration(0); stepperLeft.setAcceleration(0);
  stepperRight.setSpeed(0); stepperLeft.setSpeed(0);
  stepperRight.runSpeed(); stepperRight.runSpeed();
  stepperRight.setAcceleration(2000); stepperLeft.setAcceleration(2000);
  stepperRight.setMaxSpeed(2000); stepperLeft.setMaxSpeed(2000);
  stepperRight.setCurrentPosition(0); stepperLeft.setCurrentPosition(0);
  Serial.print("Current Pos: ");
  Serial.println(stepperRight.currentPosition());
}

void goToMyHeight() {
  stepperRight.moveTo(myHeight);
  stepperLeft.moveTo(-myHeight);
  while(stepperRight.distanceToGo() > 0) {
    stepperRight.run();
    stepperLeft.run();
   }
   Serial.print("Current Pos: ");
   Serial.println(stepperRight.currentPosition());
}
