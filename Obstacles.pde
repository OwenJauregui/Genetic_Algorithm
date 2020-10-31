// Class that contains the all the walls as obstacles for the 
// cells. It does the according methods when checking collisions
// and designing the obstacles map

public class Obstacles{
  
  // Arraylist of all the walls created
  private ArrayList<Wall> obst;
  // Wall currently being edited
  private Wall temp;
  
  // Obstacles constructor, initialices the obst arraylist.
  public Obstacles(){
    obst = new ArrayList();
  }
  
  // Creates a new wall that is beign edited.
  public void create(float x, float y){
    temp = new Wall(x, y);
  }
  
  // Sets the dimensions of the current wall being edited
  // and adds it to the obst arraylist.
  public void insert(float x, float y){
    temp.setDimensions(x - temp.getX(), y - temp.getY());
    obst.add(temp);
  }
  
  // Checks if the PVector is touching any of the obstacles
  public boolean collision(PVector cell){
    // Iterates for each wall of the obstacles
    for(Wall w : obst){
        float left, right, up, down;
        
        // Sets the left, right, up and down edges of the wall
        if (w.dimX() > 0){
          right = w.getX() + w.dimX();
          left  = w.getX();
        } else {
          right  = w.getX();
          left = w.getX() + w.dimX();
        }
        if (w.dimY() > 0){
          up = w.getY() + w.dimY();
          down  = w.getY();
        } else {
          up  = w.getY();
          down = w.getY() + w.dimY();
        }
        
        // If the PVector is in between the edges, there is a collision
        if((left < cell.x && cell.x < right) && (down < cell.y && cell.y < up)){
          return true;
        }
      }
      return false;
  }
  
  // Displays the obstacles on screen.
  public void show(){
    
    // Checks if there is a current wall being edited.
    if(editing){
      noStroke();
      fill(100, 100, 255, 100);
      
      // Draws the current wall being edited from the
      // x and y position of the wall to the x and y
      // position of the mouse.
      float dimX = mouseX - temp.getX();
      float dimY = mouseY - temp.getY();
      rect(temp.pos.x, temp.pos.y, dimX, dimY);
    }
    
    // Displays all the walls on screen.
    for(Wall w : obst){
      w.show();
    }
  }
  
  // Deletes the last wall created.
  public void pop(){
    // Checks if there is actually a wall to delete.
    if(!obst.isEmpty()){
      obst.remove(obst.size() - 1);
    }
  }
}
