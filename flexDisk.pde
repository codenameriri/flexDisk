import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;
import java.util.Map; // Include for hashmaps

// Use a hashmap to pass in inputs. key = name of input (flex, pressure, brainwave, pulse). value = tick rate (how often you want that input to update it's data, in ms).
HashMap<String,Integer> inputSettings = new HashMap<String,Integer>();
DataGenerator exampleGenerator;

Serial port; //serial port

float flexValue;
float flexRange = 1024; 

int numPts = 32;
float minRadius = 100;
float radiusRange = 50;

PVector[] points = new PVector[numPts]; // Stores the circle's points
float angle = TWO_PI/numPts;

// Arduino object and properties
Arduino arduino;
int potPin = 2;
boolean play = true;

void setup(){
  size(600, 600);
  println(Arduino.list());
  arduino = new Arduino(this, "COM4", 57600);
  

  inputSettings.put("flex", 1000);
  // Create generator, passing it our settings.
  exampleGenerator = new DataGenerator( inputSettings );
}

void draw(){
  translate(width/2, height/2);
 
  background(170, 121, 240);
  drawDisk(); 
  
  // Data from the flex sensor 
  flexValue =  arduino.analogRead(potPin) ;
 
 //Data from Data Generator
 //flexValue = Float.parseFloat(exampleGenerator.getInput("flex"));  
 
  println("flex Value: " + flexValue);
 
  noFill();
  strokeWeight(1);
  beginShape();
  
  // For each numPts assign a coordinate point, store it in a PVector array
  // From the start every point will have the same radius
  for(int n = 0; n < numPts; n++){
    float xPt = cos(angle * n);
    float yPt = sin(angle * n);
    points[n] = new PVector(xPt,yPt);
      
    // The flex values(fValue) are proportional to the radiusRange  
    float radius = minRadius + (( radiusRange * flexValue )/flexRange);  
    //println("Radius: " + radius);
    
    //changes the raidus value depending on the flexValue range
    if(flexValue > 0 && flexValue < 50.0){
       radius += random(5);
     }
     else if(flexValue > 50.0 && flexValue < 100){
       radius  += random(15, 25);
     }
     else if(flexValue == 100){
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
}//END darwDisk()
