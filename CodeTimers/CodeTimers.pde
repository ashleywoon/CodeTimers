/*
  Code Timers
  by Ashley Woon
  
  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) — not used, sensor unavailable
*/

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;

int switchValue = 0;
int potValue = 0;
int ldrValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 0;

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;

// Potentiometer reacting Timer
Timer potTimer;
float slideTime = 0;
float minSlideTime = 100;
float maxSlideTime = 1000;
int defaultTime = 1500;

// mouse click reacting timer
Timer clickTimer;
float clickTime = 0;
float minClickTime = 100;
float maxClickTime = 1000;

void setup() {
   size(1000,600);
   // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM3",  115200); 
  
  // allocating timers
  potTimer = new Timer(defaultTime);
  clickTimer = new Timer(defaultTime);
}

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 3 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
      
      // change the pot timer
      slideTime = map(potValue, minPotValue, maxPotValue, minSlideTime, maxSlideTime);
      potTimer.setTimer(int(slideTime));
      //change the click timer
      clickTime = map(potValue, minPotValue, maxPotValue, minClickTime, maxClickTime);
      clickTimer.setTimer(int(clickTime));
   }
  }
} 

void draw() {
  checkSerial();
  
  drawBackground();
  checkTimer(); 
}

void drawBackground() {
   background(0);
}

void checkTimer() {
  if(potTimer.expired()) {
    println("Pot Restart");
    potTimer.start();
  }
  if(clickTimer.expired()) {
    println("Click Restart");
    clickTimer.start();
  }
}
