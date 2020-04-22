/*
 * Code Timers
 * by Ashley Woon
 * 
 */

 //External pins
 const int led = 15;
 const int button = 12;
 const int pot = A2;
 const int ldr = A1;
 //Analog values, track for formatting to serial
 int buttonValue = 0;
 int potValue = 0;
 int ldrValue = 0;
 
void setup() {
  //Initializing pins, inputs, and output
  pinMode(led, OUTPUT);

  pinMode(button, INPUT);
  pinMode(pot, INPUT);
  pinMode(ldr, INPUT);
  Serial.begin(115200);
}

void loop() {
  getButtonValue();
  getPotValue();
  getLDRValue();
  ldrValue = potValue; //LDR not available
  sendSerialData();

}

//-- look at the momentary switch (button) and show on/off
//-- display in the serial monitor a well
void getButtonValue() {
  buttonValue = digitalRead(button);
  
  if( buttonValue == true ) {
     // Button is ON turn the LED ON by making the voltage HIGH
    digitalWrite(led, HIGH);   
  } 
  else {
    // Button is ON turn the LED ON by making the voltage LOW
    digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW      
  }
}

void getPotValue() {
  potValue = analogRead(pot); 
}

void getLDRValue() {
  ldrValue = analogRead(ldr); 
}

//-- this could be done as a formatted string, using Serial.printf(), but
//-- we are doing it in a simpler way for the purposes of teaching
void sendSerialData() {
  // Add switch on or off
  if( buttonValue ) {
    Serial.print(1);
  }
  else {
    Serial.print(0);
  }

   Serial.print(",");
   Serial.print(potValue);

   Serial.print(",");
   Serial.print(ldrValue);
   
  // end with newline
  Serial.println();
}
