import processing.sound.*;
import processing.serial.*;

Serial myPort;
Road road;
Car car;
Obstacles obstacles;
GameManager gameManager;
SoundManager soundManager;
String val;
int roadInputTarget;
int carInputTarget;

final int height = 900;
final int width = 1500;

final int inputMax = 900;

color backgroundColor = color(248, 189, 196);
color obstaclesColor = color(246, 91, 227);
color textColor = color(246, 121, 229);

void settings() {
    size(width, height);
}

void setup() {
  myPort = new Serial(this, "COM4", 9600);
  frameRate(60);
  gameManager = new GameManager();
  road = new Road(false);
  car = new Car(false);
  car.setup();
  obstacles = new Obstacles(false);
  SoundFile music = new SoundFile(this, "InitialEChiptuneVersion.wav");
  SoundFile carCrash = new SoundFile(this, "CarCrash.wav");
  soundManager = new SoundManager(music, carCrash);
}

void draw() { 
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if(val != null) {
      String[] splitedInput = val.split("\\s+");
      roadInputTarget = (Integer.parseInt(splitedInput[0])*height)/inputMax;
      carInputTarget = (Integer.parseInt(splitedInput[1])*height)/inputMax;
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
  
  
    if(gameManager.GameEnded() && !gameManager.gameEndMode) {
      gameManager.timeEnd = millis();
      gameManager.gameEndMode = true;
      soundManager.StopMusic();
      soundManager.PlayCrash();
    }
    
    if(gameManager.gameEndMode && millis() > gameManager.timeEnd + gameManager.timeEndDuration) {
      gameManager.ResetGame();
    }
}


class GameManager {
  
  int startTime = 0;
  
  boolean gameStarted = false;
  boolean gameStarting = false;
  boolean gameEndMode = false;
  
  boolean carLost = false;
  boolean roadLost = false;
  
  float matchingTime = 0;
  float matchingDuration = 3000; // in ms
  
  float timeEnd = 0;
  float timeEndDuration = 5000;
  
  public boolean GameEnded() {
    return carLost || roadLost; 
  }
  
  public int GameDuration() {
    return millis() - startTime;
  }
  
  public void ResetGame() {
    gameEndMode = false;
    gameStarting = false;
    gameStarted = false;
    carLost = false;
    roadLost = false;
    car.Reset();
    obstacles.Reset();
    road.Reset();
  }
  
  public void Update() {
    if(GameDuration() > 30000) {
      road.roadWidth = 85;
      obstacles.obstacleWidth = 370;
    }
    
    else if(GameDuration() > 30000) {
      road.roadWidth = 100;
      obstacles.obstaclesScrollingSpeed = 7;
      road.seperationX = 7;
      obstacles.obstacleWidth = 340;
    }
    else if(GameDuration() > 20000) {
      road.roadWidth = 125;
      //road.drag = 0.02f;
      obstacles.obstaclesScrollingSpeed = 6;
      road.seperationX = 6;
      obstacles.generationInterval = 2500;
      obstacles.obstaclesCount = 2;

      obstacles.obstacleWidth = 310;
    }
    else if(GameDuration() > 15000) {
      road.roadWidth = 155;
      obstacles.obstacleWidth = 280;
    }
    
    else if(GameDuration() > 10000) {
      road.roadWidth = 180;
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
        soundManager.StartMusic();

      }
      gameStarting = true;
      
      fill(textColor);
      textSize(80);
      float timerDelta = (matchingDuration-(millis() - matchingTime))/1000 ;
      text("Game Starting... " + timerDelta, 100, height/2); 
    }
    else {
      gameStarting = false;
      
    }
    
    if(!gameStarted && !gameStarting) {
      fill(textColor);
      textSize(80);
      text("Align the road and the car", 60, height/2); 
    }
    
    if(carLost) {
      fill(textColor);
      textSize(80);
      text("Car Lost !", 60, height/2); 
    }
    
    
    if(roadLost) {
      fill(textColor);
      textSize(80);
      text("Road Lost !", 60, height/2); 
    }
  }
}
