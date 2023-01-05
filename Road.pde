class Road {
  // Road data
  float posX = width/2;
  float seperationX = 5;
  ArrayList<RoadPoint> points = new ArrayList();
  float pointPlacementInterval = 100; // in ms
  float lastPointTime = 0;
  int maxPointsInRoad = 200;
 
  float roadWidth = 200;
  
  // Movement
  public float posY = height/2;
  float targetY = height/2;
  float drag = 0.01f;
  
    
    
  private Road localSave;
  Road(boolean isSave) {
    if(!isSave)
      localSave = new Road(true);
  }
  
  public void Reset() {
    points.clear();
    pointPlacementInterval = localSave.pointPlacementInterval;
    road.seperationX = localSave.seperationX;
    roadWidth = localSave.roadWidth;
    drag = localSave.drag;
  }
  
  public void Draw(){
    stroke(#DEF6CA);
    for(int i = 0; i < points.size()-1; i++) {
      strokeWeight(points.get(i).width);
      line(posX - seperationX * i, points.get(i).y, posX - seperationX * (i+1), points.get(i+1).y);
    }
  }
  
  public void Move(int target) {
    targetY = target;
    posY = lerp(posY, targetY, drag);
    
    if(get((int)posX, (int)posY) == obstaclesColor ||
       get((int)(posX + roadWidth/2), (int)posY) == obstaclesColor ||
       get((int)posX, (int)(posY + roadWidth/2)) == obstaclesColor ||
       get((int)posX, (int)(posY - roadWidth/2)) == obstaclesColor) {
       gameManager.roadLost = true;
       println("Road lost here !");
    }
  }
  
  public void PlacePoints() {

    if(millis() > lastPointTime) {
      lastPointTime = millis();
      points.add(0, new RoadPoint(posY, roadWidth));
      
      if(points.size() > maxPointsInRoad) {
        points.remove(points.size()-1);
      }
    }
  }
}

public class RoadPoint {
   float width;
   float y;
   
   RoadPoint(float y, float width) {
     this.y = y;
     this.width = width;
   }
}
