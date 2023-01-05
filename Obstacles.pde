class Obstacles {
  float generationInterval = 2000; // in ms
  float lastObstacleTime = 0; 
  float obstacleWidth = 150;
  float obstaclesScrollingSpeed = 5;
  float obstaclesCount = 1;
  
  float wallStartPos = width;
  float wallWidth = 20;
  
  ArrayList<Vector2> obstacles = new ArrayList();
  
  public void Move() {
    if(wallStartPos > 0) {
      wallStartPos -= obstaclesScrollingSpeed;
    }
    else {
      wallStartPos = 0;
    }
    for(int i = 0; i < obstacles.size(); i++) {
      obstacles.get(i).x -= obstaclesScrollingSpeed;
    }
  }
  
  public void Draw() {
    fill(obstaclesColor);
    stroke(obstaclesColor);
    rect(wallStartPos, 0, width, wallWidth);
    rect(wallStartPos, height-wallWidth-(wallWidth/2), width, wallWidth);
    
    if(millis() > lastObstacleTime + generationInterval) {
      lastObstacleTime = millis();
      
      for(int i = 0; i < obstaclesCount; i++) {
        obstacles.add(new Vector2(width  + 100, random(height), obstacleWidth));
      }
    }
    
    for(int i = 0; i < obstacles.size(); i++) {
      circle(obstacles.get(i).x, obstacles.get(i).y, obstacles.get(i).width);
    }
  }
}

class Vector2 {
  float x;
  float y;
  float width = 150;
  
  Vector2(float x, float y, float width) {
    this.x = x;
    this.y = y;
    this.width = width;
  }
}
