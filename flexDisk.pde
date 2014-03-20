float flexValue = 0;
float radius;
 
void setup(){
  size(600, 600);
}

void draw(){
  translate(width/2, height/2);
  //println("frame count: " + frameCount);
  if(frameCount % 10 == 0){
    rotate(radians(frameCount *2 % 360));    
    background(170, 121, 240);
    
    flexValue = random(100); //Data from the flex sensor should go here
    //println("flex Value: " + flexValue);
    
    drawDisk();
    drawScratches(flexValue);
    //delay(100);
  }     
}//end draw()

void drawScratches(float fValue){  
  PVector[] coordinates = createPoints(100, 100, 50, fValue);
 
  stroke(255,44,231);
  strokeWeight(1);
  
  //Draw a line from previous point to the next
  for(int n = 0; n <= coordinates.length; n++){
    int oldPt = n % coordinates.length;
    int newPt = ( n+1 ) % coordinates.length; 
    line(coordinates[oldPt].x, coordinates[oldPt].y, coordinates[newPt].x, coordinates[newPt].y );
   }
}


PVector[] createPoints(int numPts, float minRadius, float radiusRange, float fValue){
  PVector[] points = new PVector[numPts]; //stores the points
  float angle = TWO_PI/numPts;
  
  //the flex values(fValue) are proportional to the radiusRange  
  radius = minRadius + ((radiusRange*fValue)/100);    
  
  //For each numPts assign a coordinate point, store it in a PVector array
  //From the start every point will have the same radius
  for(int n = 0; n < numPts; n++){           
    float x = cos(angle * n);
    float y = sin(angle * n);
    points[n] = new PVector(x,y);
    points[n].mult(radius);
  }
  
  //Change a couple of individual points based on fValue
  if(fValue != 0){
    for(int i=0; i <= 10; i++){
      if(fValue < 50){      
        points[i].sub(3, 3, 0);
      }else if(fValue > 50){
        points[i].add(3, 3, 0);
      }
    }
  }
  return points;
}//end of createPoints()


void drawDisk(){
  strokeWeight(5);
  stroke(17,224,245);
  //Disk
  fill(0);
  ellipse(0, 0, 500, 500);
  
  //Inner hole
  strokeWeight(2);
  fill(170, 121, 240); //Has to be the same color as the background
  ellipse(0, 0, 65, 65);
  //line(0,0, 100, 100);
}//end of drawDisk()
