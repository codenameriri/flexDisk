import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;

// For the Data Generator
// Use a hashmap to pass in inputs. key = name of input (flex, pressure, brainwave, pulse). value = tick rate (how often you want that input to update it's data, in ms).
import java.util.Map;
HashMap<String,Integer> inputSettings = new HashMap<String,Integer>();
DataGenerator exampleGenerator;

String diskType; //"flex" or "pressure"

float flexValue;
float maxFlex; // = 100; //1024 ------------------------------------> CHANGE 

int numPts = 32; // Increasing the value, will cause more jaggers
float minRadius = 50; 
float maxRadius = 120;


PVector[] points = new PVector[numPts]; // Stores the circle's points
float angle = TWO_PI/numPts;

// Arduino object and properties
Arduino arduino;
int potPin = 2;
boolean play = true;



void setup(){
  size(600, 600);
  frameRate(60);
  diskType = "flex";
  
  //println(Arduino.list());
  try{
    arduino = new Arduino(this, "COM4", 57600);
  }catch(Exception e){
    play = false;
  }
  
  inputSettings.put(diskType, 100);
  // Create generator, passing it our settings.
  exampleGenerator = new DataGenerator( inputSettings );
}

void draw(){
  translate(width/2, height/2);
  background(170, 121, 240);
  drawDisk(); 
  
  if(play == false ){ 
    maxFlex = 100;
    // For the Data Generator
    flexValue = ( Float.parseFloat(exampleGenerator.getInput(diskType)) );  
  }else{
    maxFlex = 1023;
    // Data from the flex sensor 
    flexValue =  arduino.analogRead(potPin);
  }
  
  println("\nFlex Value: " + flexValue);
  
 
  // For changing the stroke color for flex or pressure
  if(diskType == "flex"){
    stroke(240,13,252);
  }else if(diskType == "pressure"){
    stroke(17,224,245);
  }
  
  strokeWeight(1);
  noFill();
  beginShape();
  // For each numPts assign a coordinate point, store it in a PVector array
  // From the start every point will have the same radius
  for(int n = 0; n < numPts; n++){
    float xPt = cos(angle * n);
    float yPt = sin(angle * n);
    points[n] = new PVector(xPt,yPt);
      
    // Return a flexValue thats corresponds to the radius' range    
    float radius =  map(flexValue, 0, maxFlex, minRadius, maxRadius);

    //changes the raidus value depending on the flexValue range
    if( flexValue == 0 ){
      radius += random(1);
    } 
    if( flexValue > 0 && flexValue < (maxFlex*0.25) ){ 
      radius += random(5);
    }
    else if( flexValue > (maxFlex*0.25) && flexValue < (maxFlex*0.5) ){ 
      radius += random(5, 15);
    }
    else if( flexValue > (maxFlex*0.5) && flexValue < (maxFlex*0.75) ){ 
      radius += random(15, 25);
    }
    else if( flexValue > (maxFlex*0.75) && flexValue <= maxFlex){
      radius  += random(25, 45);
    }

    points[n].mult(radius);
    
    // The first control point and the start point of the curve use the same point
    // therefore we need to repeat the curveVertex() using the same point
    if(n == 0 ){
      curveVertex(points[n].x, points[n].y);
    }
    curveVertex(points[n].x, points[n].y);
     
    // The last point of curve and the last control point use the same point
    if(n == numPts-1){
      // In this case, the last point will be the same as the starting point b/c its a circle
      curveVertex(points[0].x, points[0].y);
      curveVertex(points[0].x, points[0].y);
    }
  }// END for
  endShape(CLOSE);
  
  text(("Flex Value(from generator): " + flexValue), 0, 100, width, height );
}//END draw()

// Draws the disk in the background
void drawDisk(){
  strokeWeight(5);
  stroke(17,224,245);
  // Disk
  fill(0);
  ellipse(0, 0, 500, 500);
  
  // Inner hole
  strokeWeight(2);
  fill(170, 121, 240); // Has to be the same color as the background
  ellipse(0, 0, 65, 65);
  
  //--------------------------FOR DEBUGGING----------------
 /* noFill();
  strokeWeight(1);
  stroke(150);
  line(0,0, 200, 0);
  ellipse(0, 0, 100, 100);
  ellipse(0, 0, 300, 300);*/
  //---------------------------------------------------------
}//END darwDisk()
