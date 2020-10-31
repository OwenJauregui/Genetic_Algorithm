// Class of the cells whose objective is to get from a starting
// point to a goal and that, collectively, will search for the best 
// route posible using a genetic algorithm

public class Cell{
    
    // List of the cell's genes (direction changes)
    private float genes[] = new float[maxSteps];
    private PVector pos, // Current cell position
                    facing, // Direction where the cell is facing at
                    repRange = new PVector(0, 0); // Its reproduction range
    private int moves; // Amount of moves it has done
    private float fit; // How well did the cell do
    private boolean crash, // Cell has crashed
                    finish, // Cell arrived to the goal
                    death, // Cell has died
                    champ = false, // Best of the past generation
                    crashWall = false; // Crashed into an obstacle
    
    // Cell constructor for the first generation
    public Cell(){
      // Sets all the atrributes to initial values
      pos = new PVector(inicio.x, inicio.y);
      fit = 0;
      moves = 0;
      facing = new PVector(0, 1);
      crash = false;
      finish = false;
      death = false;
      startUp();
    }
    
    // Cell constructor for the generations that have parents
    public Cell(Cell p1, Cell p2){
      pos = new PVector(inicio.x, inicio.y);
      fit = 0;
      moves = 0;
      facing = new PVector(0, 1);
      crash = false;
      finish = false;
      death = false;
      child(p1, p2);
    }
    
    // Creates random direction genes for the first generation
    public void startUp(){
      // First direction can take any 360 degree angle
      genes[0] = random(-PI, PI);
      // Creation of the rest of the genes
      for(int i = 1; i < genes.length; i++){
        // Small turns with a range of 45 degrees maximum for each side
        genes[i] = random(-HALF_PI/4, HALF_PI/4);
      }
    }
    
    // Makes the cell become the "champ" or the best cell of the past gen
    // and resets to the original starter values
    public void champ(){
      pos = new PVector(inicio.x, inicio.y);
      fit = 0;
      moves = 0;
      facing = new PVector(0, 1);
      crash = false;
      finish = false;
      death = false;
      champ = true;
    }
    
    // Displays the cell on the window
    public void disp(){
      noStroke();
      if(champ){
        // Different color in case it's the best cell of the past gen
        fill(255, 100, 100);
      } else{
        fill(255);
      }
      ellipse(pos.x, pos.y, 5, 5);
    }
    
    // Moves the cell to its next position according to its genes
    public void move(){
      // Cheack if the cell hasn't died, crashed or arrived to the goal
      if(!crash && !finish && !death){
        // Changes direction according to its genes and moves forward
        pos.add(facing.rotate(genes[moves]).setMag(1));
        moves++; // Increments the amount of moves it has taken
      }
    }
    
    // Checks if the cell has collided with the edges or any wall
    public void collision(){
      if((pos.x > width || pos.x < 0) || (pos.y > height || pos.y < 0)){
        // If it has crashed to any edges
        crash = true;
      } else if (obs.collision(pos)) {
        // If it has crashed to an obstacle
        crash = true;
        crashWall = true;
      }
    }
    
    // Checks if the cell arrived to the goal
    public void finish(){
      // If the position of the cell touches the circunference of the goal
      if(dist(pos.x, pos.y, goal.x, goal.y) <= goalRadius){
        finish = true;
      }
    }
    
    // Checks if the cell has died. A cell has died if it craches, or 
    // arrived to the goal
    public void death(){
      if((moves >= maxSteps || crash || finish) && !death){
        death = true;
        fitCalc(); // This calculates how well the cell did
        // This part determines how likely is for a cell to reproduces
        repRange.x = ant;
        repRange.y = ant + fit;
        ant = ant + fit;
      }
    }
    
    // Calculates haw well the cell did acording to the moves it took, how
    // close it was to the goal and if it arrived to the goal
    public void fitCalc(){
      float dist = dist(pos.x, pos.y, goal.x, goal.y);
      if(finish){
        // Beter fit points if it arrived to the goal, and if it took
        // less moves for it to get there
        fit = 50 + 100.0/(moves * moves);
        if(maxSteps > moves && nMSteps > moves){
          // The max quantity of moves decreses to the minimum steps taken
          // by any cell, this forces the cells to get better next generations
          nMSteps = moves;
        }
      } else {
        // Fit according to how close it was to the goal
        fit = 1.0/(dist * dist);
        
        // Decreasing points in case it crashed into a wall to make the cells
        // avoid the walls in future generations
        fit -= (int(crashWall)*0.1)/(dist*dist);
      }
      // The fit points combined all of the cells had
      totalFit += fit;
    }
    
    // Checks if the cell has the "selected" cuantity in the reproduction range
    public boolean selected(float selected){
      if(repRange.x <= selected && repRange.y > selected){
        // In case the number is in range, that means it was selected to reproduce
        return true;
      }
      return false;
    }
      
    // Creates the genes of a child cell based on its parents' genes
    public void child(Cell p1, Cell p2){
      // Cicle that itrates, creating a gene on each iteration
      for(int i = 0; i < genes.length; i++){
        // Selects parent 1 or parent 2 to inheritate the gene on the i position
        if(floor(random(0, 2)) == 1){
          genes[i] = p1.genes[i];
        } else {
          genes[i] = p2.genes[i];
        }
        
        // Random 1 in 100 chance of current gene to mutate
        if(floor(random(0, 100)) == 0){
          genes[i] = random(-HALF_PI/4, HALF_PI/4);
        }
      }
    }
    
    // Method that returns the fit
    public float getFit(){
      return fit;
    }
    
    // Method that returns true if the cell is death
    public boolean isDeath(){
      return death;
    }
    
    // Method that returns true if the cell was the best in the past generation
    public boolean isChamp(){
      return champ;
    }
    
    
}
