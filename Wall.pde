// Class that conforms the obstacles for the cells, it has
// position and dimensions, can display itself, and will be
// used by "Obstacles"

public class Wall{
  
  // Position and dimensions of the wall
  private PVector pos;
  private PVector dimensions;
  
  // Constructor for the wall, seting its starting x and y 
  // coordinates
  public Wall(float x, float y){
    pos = new PVector(x, y);
  }
  
  // Display the wall on screen
  public void show(){
    noStroke();
    fill(100, 100, 255);
    rect(pos.x, pos.y, dimensions.x, dimensions.y);
  }
  
  // Sets the x and y dimensions for the wall
  public void setDimensions(float x, float y){
    dimensions = new PVector(x, y);
  }
  
  // Returns its position's x component
  public float getX(){
    return pos.x;
  }
  
  // Returns its position's y component
  public float getY(){
    return pos.y;
  }
  
  // Returns its dimensions' x component
  public float dimX(){
    return dimensions.x;
  }
  
  // Returns its dimensions' y component
  public float dimY(){
    return dimensions.y;
  }
}
