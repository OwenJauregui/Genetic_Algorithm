/*/
Little visual program that makes "Cells" learn to get to a goal and avoid
obstacles from a starting position by using a genetic algoritm.

Created: 02/11/2020
Modified: 10/30/2020
By: Owen Jauregui Borbon
/*/


// Global variables used for the program
final PVector inicio = new PVector(250, 450), // Starting position
              goal = new PVector(250, 50); // Goal position
final int population = 700, // Cells per generation
          goalRadius = 25; // Goal's radius
ArrayList<Cell> generation = new ArrayList(), // Current generation of cells
                children = new ArrayList(); // Next generation of cells
float totalFit = 0, // Fit points obtained by all of the cells combined
      ant = 0; // Start of the reproduction range of the last cell
int genCount = 0, // Total of generations
    maxSteps = 1000, // Max moves that the cells are allowed to take
    nMSteps = maxSteps; // Max moves for the next generation
boolean nextGen = true, // Start the next generation
        showAll = true, // Show all the cells or only the best from past gen
        start =false, // Start, pause or continue the evolution
        editing = false; // If wall is currently being place
Obstacles obs = new Obstacles(); // Set of obstacles

// Creation of the first generation and window specifications
public void setup(){
  background(0);
  size(500, 500);
  for(int i = 0; i < population; i++){
    generation.add(new Cell());
  }
  frameRate(100);
}

// Main program loop
public void draw(){
  background(0);
  
  //Display the current generation on window
  textSize(20);
  fill(255);
  text("Gen: " + genCount, 10, 30);
  
  // Display de goal on the window
  noStroke();
  fill(150, 255, 150);
  ellipse(goal.x, goal.y, goalRadius*2, goalRadius*2);
  
  // Display obstacles on the window
  obs.show();
  
  // Cells updates
  evolution();
}

// Selection of the parents used for the next generation
// and creation of the new generation
public void selection(){
  Cell champ = new Cell();
  float bestFit = 0;
  // Selection of the fittest cell that will pass to the next gen
  for(Cell c : generation){
    if(c.getFit() > bestFit){
      champ = c;
      bestFit = c.getFit();
    }
  }
  // Fittest cell stays in the next gen
  children.add(champ);
  children.get(0).champ();
  
  // Creation of a new cell until the gen is completed
  for(int i = 1; i < population; i++){
    Cell parent1 = search(floor(random(0, totalFit)));
    Cell parent2;
    
    // Parents selection, making sure there is 2 different 
    // cells as parents
    do{
      float s = random(0, totalFit);
      parent2 = search(s);
    } while(parent1 == parent2);
    children.add(new Cell(parent1, parent2));
  }
  
  // The children become the new generation
  generation.clear();
  for(Cell c : children){
    generation.add(c);
  }
  children.clear();
  
  // All global variables related to the gen get updated
  genCount++;
  nextGen = false;
  totalFit = 0;
  ant = 0;
  maxSteps = nMSteps;
}

// Makes the cells do all the methods that have to be done
// on each main loop iteration
public void evolution(){
  
  // This checks if the evolution already started and if
  // the evolution process is paused
  if(start){
    nextGen = true;
    // Cicle for doing every cell's actions
    for(int i = 0; i < population; i++){
      Cell cell = generation.get(i);
      
      // Check for collisions
      cell.collision();
      
      // Display the cell depending if you only want to see
      // the best cell of the last generation or all the cells
      if(showAll || cell.isChamp()){ 
        cell.disp();
      }
      
      // Move the cell, check if it got to the goal or if it died
      cell.move();
      cell.finish();
      cell.death();
      
      // Check if every cell is death so it gets to the next gen
      if(nextGen && !cell.isDeath()){
        nextGen = false;
      }
    }
    
    // In case all cells where dead, the selection process makes 
    // the new generation
    if(nextGen){
      selection();
    }
  }
}

// Looks for the cell that has certain reproduction range
public Cell search(float rep){
  boolean ready = false;
  int place = 0;
  while(!ready){
    if(generation.get(place).selected(rep)){
      ready = true;
    } else {
      place++;
    };
  }
  return generation.get(place);
}

// Event when a key is pressed
public void keyPressed(){
  if (keyCode == 32){ 
    // If the key pressed was space bar
    showAll = !showAll;
  } else if (keyCode == 8 && genCount == 0){
    // If the key pressed was backspace and the evolution hasn't started
    obs.pop();
  } else if (key == ENTER && !editing){
    // If the key pressed was enter and there's no wall being edited
    start = !start;
    genCount = genCount==0?1:genCount;
  }
}

// Event when a mouse is pressed
public void mousePressed(){
  // Checks if the evolution hasn't started
  if(genCount == 0){
    // Creates a new wall in the obstacles starting from the mouse position
    obs.create(mouseX, mouseY);
    editing = true;
  }
}

// Event when a mouse is released
public void mouseReleased(){
  // Checks if the evolution hasn't started
  if(genCount == 0){
    // Sets the dimensions of the wall currently being edited using the mouse
    // current position
    obs.insert(mouseX, mouseY);
    editing = false;
  }
}
