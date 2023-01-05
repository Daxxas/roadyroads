import processing.serial.*;

Serial myPort;
Road road;
Car car;
Obstacles obstacles;
GameManager gameManager;
String val;
int roadInputTarget;
int carInputTarget;

final int height = 1000;
final int width = 1000;
color backgroundColor = color(100, 0, 255);
color obstaclesColor = color(200, 50, 100);

void settings() {
    size(width, height);
}

void setup() {
  myPort = new Serial(this, "COM4", 9600);
  frameRate(60);
  gameManager = new GameManager();
  road = new Road();
  car = new Car();
  car.setup();
  obstacles = new Obstacles();
}

void draw() {
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if(val != null) {
      String[] splitedInput = val.split("\\s+");
      roadInputTarget = Integer.parseInt(splitedInput[0]);
      carInputTarget = Integer.parseInt(splitedInput[1]);
    }
  } 
  
  background(backgroundColor);
  
  
  if(gameManager.gameStarted) {
    if(!gameManager.GameEnded()) {
      gameManager.Update();
      obstacles.Move();
    }
    obstacles.Draw();
  }
    if(!gameManager.GameEnded()) {
      road.Move(roadInputTarget);
      road.PlacePoints();
    }
  road.Draw();
  
  if(!gameManager.GameEnded()) {
    car.Move(carInputTarget);
  }
  car.Draw(); 
  
  gameManager.Draw();
  
  
      
      if(gameManager.GameEnded()) {
        gameManager.ResetGame(); 
      }

}


class GameManager {
  
  int startTime = 0;
  
  boolean gameStarted = false;
  boolean gameStarting = false;
  
  boolean carLost = false;
  boolean roadLost = false;
  
  float matchingTime = 0;
  float matchingDuration = 3000; // in ms
  
  
  public boolean GameEnded() {
    return carLost || roadLost; 
  }
  
  public int GameDuration() {
    return millis() - startTime;
  }
  
  public void ResetGame() {
    car = new Car();
    road = new Road();
    obstacles = new Obstacles();
    gameStarting = false;
    gameStarted = false;
    carLost = false;
    roadLost = false;
  }
  
  public void Update() {
      if(GameDuration() > 1000) {
        road.roadWidth = 150;
        obstacles.obstacleWidth = 250;
      }
  }
  
  public void Draw() {
    if(abs(car.posY) - abs(road.posY) < road.roadWidth/2 &&
      abs(car.posY) - abs(road.posY) > -road.roadWidth/2 &&
      !gameStarted) {
      if(gameStarting == false) { // On the frame they started matching
        matchingTime = millis();
      }
      else if(millis() > matchingTime + matchingDuration) {
        gameStarted = true;
        startTime = millis();
      }
      gameStarting = true;
      
      fill(0, 408, 612);
      textSize(80);
      float timerDelta = (matchingDuration-(millis() - matchingTime))/1000 ;
      text("Game Starting... " + timerDelta, 100, height/2); 
    }
    else {
      gameStarting = false;
      
    }
    
    if(!gameStarted && !gameStarting) {
      fill(0, 408, 612);
      textSize(80);
      text("Align the road and the car", 60, height/2); 
    }
    
    if(carLost) {
      fill(0, 408, 612);
      textSize(80);
      text("Car Lost !", 60, height/2); 
    }
    
    
    if(roadLost) {
      fill(0, 408, 612);
      textSize(80);
      text("Road Lost !", 60, height/2); 
    }
  }
}
