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
float minSlideTime = 1000;
float maxSlideTime = 5000;
int defaultTime = 1500;

//slideshow / state machine
PImage img;
int state = 0;
//int picState = 1;
int bigState = 1;
int littleState = 2;

// mouse click reacting timer
Timer clickTimer;
float clickTime = 3000;
float r = random(0,100);
float g = random(100,255);
float b = random(50,100);

void setup() {
   // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM3",  115200); 
//-------------------------------------------------
  size(1000,800);
  // allocating timers
  potTimer = new Timer(defaultTime);
  clickTimer = new Timer(defaultTime);
  
  //load image
  //img = loadImage("healthSlogan");
}

void draw() {
  checkSerial();
  drawBackground();
  checkTimer(); 
  //if(state == 0)
  //  drawPicState();
  if(state == 1)
    drawBigState();
  else if(state == 2)
    drawLittleState();
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
      //setting click timer
      clickTimer.setTimer(int(clickTime));
   }
  }
} 

void drawBackground() {
  background(0);
}

void checkTimer() {
  if(potTimer.expired()) {
    potTimer.start();
    if(state == 3)
      state = 1;
     else
       state++;
  }

  if(clickTimer.expired()) {
    println("\tClick Restart");
    clickTimer.start();
    fill(r,g,b);
    rect(0,0, 20,1000);
    rect(980,0, 20,1000);
  }
}

//void drawPicState() {
//  image(img, 20,20);
//}


void drawBigState() {
  fill(#FFB6C1);
  textSize(50);
  rect(200,200, 400,600);
  text("SOAP IS YOUR FRIEND", 50,50);
}

void drawLittleState() {
  fill(#FFC0CB);
  text("please let the bubbles foam", 50,50);
  rect(200,200, 300,500);
  ellipse(100,100, 50,50);
  ellipse(150,115, 30,30);
  ellipse(600,350, 10,10);
  ellipse(570,500, 25,25);
  ellipse(700,600, 50,50);
  ellipse(260,200, 60,60);
  ellipse(625,420, 20,20);
  ellipse(240,490, 15,15);
}
