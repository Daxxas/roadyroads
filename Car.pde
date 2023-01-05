class Car {
 
  
  PImage playerSprite;
  float carScale = 40;
  
  float posX = 300;
  public float posY = 300;
  float carTargetY = 0;
  float carWidth = 20;
  
  float drag = 0.09;
  
  private Car localSave;
  Car(boolean isSave) {
    if(!isSave)
      localSave = new Car(true);
  }
  
  public void Reset() {
    drag = localSave.drag;
  }
  
  public void setup() {
    playerSprite = loadImage("car.png");
    imageMode(CENTER);
  }
  
  public void Move(int target) {
    carTargetY = target;
    posY = lerp(posY, carTargetY, drag);
    
    
    // Car lost here
    if(get((int)posX, (int)posY) == backgroundColor && gameManager.gameStarted) {
      gameManager.carLost = true;
    }
  }
  
  public void Draw() {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(1);

    image(playerSprite, posX, posY, playerSprite.width/carScale, playerSprite.height/carScale);
    //rect(carX, carY, carWidth, carWidth);
  }
  
}
