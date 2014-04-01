// include for hashmaps
import java.util.Map;

// use a hashmap to pass in inputs. key = name of input (flex, pressure, brainwave, pulse). value = tick rate (how often you want that input to update it's data, in ms).
HashMap<String,Integer> inputSettings = new HashMap<String,Integer>();
DataGenerator exampleGenerator;

float flexValue;
float radius;

int numPts = 100;
float minRadius = 150;
float radiusRange = 75;

PVector[] points = new PVector[numPts]; //stores the circle's points
float angle = TWO_PI/numPts;


void setup(){
  size(600, 600);
  
  inputSettings.put("flex", 1000);
  
  // create generator, passing it our settings.
  exampleGenerator = new DataGenerator( inputSettings );
}

void draw(){
  translate(width/2, height/2);
  if(frameCount % 10 == 0){  
    background(170, 121, 240);
    drawDisk(); 
    
    //Data from the flex sensor 
    flexValue = Float.parseFloat(exampleGenerator.getInput("flex"));  
    println("flex Value: " + flexValue);
    
   // Change the color
    if(flexValue >= 0 && flexValue <= 50.0){
      stroke(17,224,245);
    }
    else if(flexValue > 50.0 && flexValue <= 100.0){
      stroke(255,44,231);
    }

    // For each numPts assign a coordinate point, store it in a PVector array
    // From the start every point will have the same radius
    for(int n = 0; n < numPts; n++){          
      float x = cos(angle * n);
      float y = sin(angle * n);
      points[n] = new PVector(x,y);
      
      // The flex values(fValue) are proportional to the radiusRange  
      radius = minRadius - ((radiusRange*flexValue)/100); 
      
      if(n == int(flexValue) && (int(flexValue) != 0 || int(flexValue) != 100)){
        radius += 15;
      }
      points[n].mult(radius);
      vertex(points[n].x, points[n].y); 
    }

    stroke(255,44,231);
    strokeWeight(1);
  
    // Draw a line from previous point to the next
    for(int n = 0; n <= points.length; n++){
      int oldPt = n % points.length;
      int newPt = ( n+1 ) % points.length; 
      line(points[oldPt].x, points[oldPt].y, points[newPt].x, points[newPt].y );
     }

  }//end if()   
}//end draw()

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
}
