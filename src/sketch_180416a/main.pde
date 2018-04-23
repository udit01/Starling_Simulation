import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import javax.swing.JOptionPane;

/// array of all the starings currently in view/actually present
ArrayList<Starling> starlings;
/// array of all the obstacles currently in view/actually present
ArrayList<Obstacle> obstacles;
/// the currently selected starling whose stats are being displayed on the top right
Starling currentSelected = new Starling(0.0, 0.0);

/// the scale of the starling dimensional size and its defining radii
float scale = .8;
/// the erasing radius in the erase mode
float eraseRadius = 30;
/// the current placeTool - can be starling, obstacle, eraser or select
String placeTool = "Starlings";

/// the average speed of the flock of the currently selected starling
float averageSpeed = 0.0;
/// the average direction of the flock of the currently selected starling
double direction;

/// maximum spped that the starlings can attain
float maxSpeed = 1.6;;
/// friendly radius that defines the proximity of the neighbors
float neighborRadius = 40;
/// the minimum crowding radius between the starlings
float crowdRadius = 50;
/// the minimum distance between the starlings and the obstacles
float obstacleRadius = 100;
/// the cohesion radius between the starlings 
float coheseRadius = 40;

/// toggling option to switch on/off the neighbor influence
boolean option_neighbor = true;
/// toggling option to switch on/off the crowd influence
boolean option_crowd = true;
/// toggling option to switch on/off the obstacle influence
boolean option_obstacle = true;
/// toggling option to switch on/off the noise
boolean option_noise = true;
/// toggling option to switch on/off the cohesion
boolean option_cohese = true;
/// toggling option to switch on/off the interaction lines
boolean option_lines = true;

/// the message timer for displaying the stats and other relevant details
int messageTimer = 0;
/// the display message text string
String messageText = "";

/// sets the size of the processing window
public void settings() 
{
  size(1800, 900);
}

/// initializes the processing window with rectangular walls and random starlings
void setup () 
{
  textSize(16);
  
  starlings = new ArrayList<Starling>();
  obstacles = new ArrayList<Obstacle>();
  
  for (int x=100; x<width-100; x+= 100) 
  {
    for (int y=100; y<height-100; y+= 100) 
    {
      starlings.add(new Starling(x + random(3), y + random(3)));
    }
  }
  
  setupWalls();
}

/// creates a new rectangular obstacle wall in the window
void setupWalls() 
{
  obstacles = new ArrayList<Obstacle>();
  for (int x=40; x<width-20; x+= 20) 
  {
    obstacles.add(new Obstacle(x, 20, true));
    obstacles.add(new Obstacle(x, height-40, true));
  }
  for (int x=20; x<height-20 ; x+= 20) 
  {
    obstacles.add(new Obstacle(20, x, true));
    obstacles.add(new Obstacle(width-40, x, true));
  }
}

/// creates a new multi-circular obstacle wall in the window
void setupCircle() 
{
  obstacles = new ArrayList<Obstacle>();
  for(int x=0; x<80; x+= 1) 
  {
    float dir = (x/80.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.48), (height*0.5)+(sin(dir)*height*.48), true));
  } 
  for(int x=0; x<64; x+= 1) 
  {
    float dir = (x/64.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.32), (height*0.5)+(sin(dir)*height*.32), true));
  } 
  for(int x=0; x<32; x+= 1) 
  {
    float dir = (x / 32.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.16), (height * 0.5)+(sin(dir)*height*.16), true));
  } 
  for(int x=0; x<16; x+= 1) 
  {
    float dir = (x/16.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.08), (height*0.5)+(sin(dir)*height*.08), true));
  } 
  for(int x=0; x<8; x+= 1) 
  {
    float dir = (x/8.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.04), (height*0.5)+(sin(dir)*height*.04), true));
  } 
}

/// creates a new COP obstacle wall in the window
void setupCourse()
{
  obstacles = new ArrayList<Obstacle>();
  for(int x=12; x<60; x+= 1) 
  {
    float dir = (x/72.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.25)+(cos(dir)*height*.3), (height*0.5)+(sin(dir)*height*.3), true));
  } 
  for(int x=0; x<50; x+= 1) 
  {
    float dir = (x/50.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.5)+(cos(dir)*height*.29), (height*0.5)+(sin(dir)*height*.29), true));
  }
  for(int x=height/5 ; x<height*0.8; x+= 25) 
  {
    obstacles.add(new Obstacle(width*0.73, x, true));
  }
  for(int x=33; x<68; x+= 1) 
  {
    float dir = (x/50.0) * TWO_PI;
    obstacles.add(new Obstacle((width*0.78)+(cos(dir)*height*.18), (height*0.35)+(sin(dir)*height*.18), true));
  }
}

/// randomizes the position,color of all the starlings on the window
void randomize()
{
  for(int i=0; i<starlings.size(); i++)
  {
    Starling j = starlings.get(i);
    j.position.x = random(width);
    j.position.y = random(height);
    j.colorR = random(255);
    j.colorG = random(255);
    j.colorB = random(255);
    j.velocity.x = random(maxSpeed/2) - maxSpeed/4;
    j.velocity.y = random(maxSpeed/2) - maxSpeed/4;
  }
}

/// makes a wind flow with direction depending on the value of n
void wind(int n)
{
  if(n == 0)
  {
    for(int i=0; i<starlings.size(); i++)
    {
      Starling j = starlings.get(i);
      j.velocity.y -= 0.1;
    }
  }
  else if(n == 1)
  {
    for(int i=0; i<starlings.size(); i++)
    {
      Starling j = starlings.get(i);
      j.velocity.x += 0.1;
    }
  }
  else if(n == 2)
  {
    for(int i=0; i<starlings.size(); i++)
    {
      Starling j = starlings.get(i);
      j.velocity.y += 0.1;
    }
  }
  else if(n == 3)
  {
    for(int i=0; i<starlings.size(); i++)
    {
      Starling j = starlings.get(i);
      j.velocity.x -= 0.1;
    }
  }
}

/// increasing or decresing the cohese
void cohese(boolean direction)
{
  if(direction)
  {
    coheseRadius += 15;
  }
  else
  {
    coheseRadius -= 15;
  }
}

/// incresing or decresing the separation radius
void separation(boolean direction)
{
  if(direction)
  {
    crowdRadius += 15;
  }
  else
  {
    crowdRadius -= 15;
  }
}

/// displays the statistics in the top right corner of the window
void display() 
{
   averageSpeed = 0.0;
   
   double directionY = 0.0;
   double directionX = 1.0;
  
   for(int i=0; i<currentSelected.neighbors.size(); i++)
   {
     Starling j = currentSelected.neighbors.get(i);
     averageSpeed += pow(pow(j.velocity.x,2) + pow(j.velocity.x,2) , 0.5);
     directionX += j.velocity.x;
     directionY += j.velocity.y;
   }
   
   averageSpeed += pow(pow(currentSelected.velocity.x,2) + pow(currentSelected.velocity.x,2) , 0.5);
   directionX += currentSelected.velocity.x;
   directionY += currentSelected.velocity.y;
   
   averageSpeed /= (currentSelected.neighbors.size() + 1);
   direction = Math.atan(directionY/directionX);
}

/// displays the help section for the user
void displayHelp()
{
  JOptionPane.showMessageDialog(null,"HELP SECTION" + "\n" + "Q: Select Starlings at hand" + "\n" + "W: Select Rectangular Obstacles at Hand" + "\n" + "w: Select Circular Obstacles at Hand" + "\n" + "E: Select Eraser at hand" + "\n" + "R: Randomize the Starlings" + "\n" + "S: Select a Starling in this mode" + "\n" + "Z: Revelocity all Obstacles" + "\n" + "X: Revelocity all Starlings" + "\n" + "Up: Blow wind in the upward direction" + "\n" + "Down: Blow wind in the downward direction" + "\n" + "Left: Blow wind in the left direction" + "\n" + "Right: Blow wind in the right direction" + "\n" + "1: Toggle Interactions" + "\n" + "2: Decrease Cohesion Radius" + "\n" + "3: Toggle Obstacle Obstacleance" + "\n" + "4: Decrease Separation Radius" + "\n" + "5: Toggle Flock Alignment" + "\n" + "6: Increase Separation Radius" + "\n" + "7: Toggle Noise" + "\n" + "8: Increase Cohesion Radius" + "\n" + "9: Toggle Crowd Obstacleance" + ",: Rectangular Walls" + "\n" + ".: Circular Obstacles" + "\n" + "/: COP Wall" + "\n" + "-: Decrease Size of Starlings" + "\n" + "=: Increase size of Starlings" + "\n" + "Mouse Wheel: Change Max Speed");
}

/// describes the placeTool's visual appearance
void draw() 
{
  noStroke();
  colorMode(HSB);
  fill(0, 100);
  rect(0, 0, width, height);

  if(placeTool == "erase") 
  {
    noFill();
    stroke(0, 100, 200);
    ellipse(mouseX, mouseY, eraseRadius * 2.5, eraseRadius * 2.5);
    if (mousePressed) 
    {
      erase();
    }
  } 
  else if (placeTool == "obstacles") 
  {
    noStroke();
    fill(100, 100, 200);
    ellipse(mouseX, mouseY, 25, 25);
  }
  
  for (int i=0; i<starlings.size(); i++) 
  {
    Starling current = starlings.get(i);
    current.go();
    current.draw();
  }

  for (int i=0; i<obstacles.size(); i++) 
  {
    Obstacle current = obstacles.get(i);
    current.draw();
  }

  if (messageTimer>0) 
  {
    messageTimer -= 1; 
  }
  drawGUI();
}

/// checks the keyPressed and accounts for performing the appropriate action
void keyPressed() 
{
  if(key == CODED)
  {
    if(keyCode == UP)
    {
      wind(0);
      message("Wind: Upwards");
    }
    else if(keyCode == RIGHT)
    {
      wind(1);
      message("Wind: Rightwards");
    }
    else if(keyCode == DOWN)
    {
      wind(2);
      message("Wind: Downwards");
    }
    else if(keyCode == LEFT)
    {
      wind(3);
      message("Wind: Leftwards");
    }
  }
  
  else if(key == 'q' || key == 'Q') 
  {
    placeTool = "Starlings";
    message("Add Starlings");
  } 
  else if(key == 'w' || key == 'W') 
  {
    placeTool = "obstacles";
    message("Place obstacles");
  } 
  else if(key == 'e' || key == 'E') 
  {
    placeTool = "erase";
    message("Eraser");
  } 
  else if(key == 'r' || key == 'R')
  {
    message("Randomized the Starlings");
    randomize();
  }
  else if(key == 's' || key == 'S')
  {
    placeTool = "select";
    message("Select Mode");
  }
  else if(key == 'h' || key == 'H')
  {
    displayHelp();
  }
  else if(key == 'z' || key == 'Z')
  {
    obstacles = new ArrayList<Obstacle>();
    message("Revelocityd all obstacles");
  }
  else if(key == 'x' || key == 'X')
  {
    starlings = new ArrayList<Starling>();
    message("Revelocityd all Starlings");
  }
  
  else if(key == '-') 
  {
    message("Decreased scale");
    scale *= 0.95 ;
    maxSpeed *= 0.95 ;
    neighborRadius *= 0.95 ;
    crowdRadius *= 0.95 ;
    obstacleRadius *= 0.95 ;
    coheseRadius *= 0.95 ;
  } 
  else if(key == '=') 
  {
    message("Increased Scale");
    scale /= 0.95 ;
    maxSpeed /= 0.95 ;
    neighborRadius /= 0.95 ;
    crowdRadius /= 0.95 ;
    obstacleRadius /= 0.95 ;
    coheseRadius /= 0.95 ;
  } 
  
  else if(key == '1') 
  {
     option_lines = option_lines ? false : true;
     message("Turned interactions " + on(option_lines));
  } 
  else if(key == '2')
  {
    separation(false);
    message("Decreased Cohesion");
  }
  else if(key == '3') 
  {
     option_obstacle = option_obstacle ? false : true;
     message("Turned obstacle Obstacleance " + on(option_obstacle));
  } 
  else if(key == '4')
  {
    separation(false);
    message("Decreased Separation");
  }
  else if(key == '5') {
     option_neighbor = option_neighbor ? false : true;
     message("Turned friend allignment " + on(option_neighbor));
  } 
  else if(key == '6')
  {
    separation(true);
    message("Increased Separation");
  }
  else if(key == '7') 
  {
     option_noise = option_noise ? false : true;
     message("Turned noise " + on(option_noise));
  } 
  else if(key == '8')
  {
    separation(true);
    message("Increased Cohesion");
  }
  else if(key == '9') 
  {
     option_crowd = option_crowd ? false : true;
     message("Turned crowding Obstacleance " + on(option_crowd));
  } 
  
  else if(key == ',') 
  {
     setupWalls(); 
  } 
  else if(key == '.') 
  {
     setupCircle(); 
  } 
  else if(key == '/') 
  {
     setupCourse();
  }

}

/// displays the info messages on the window
void drawGUI() 
{
   if(messageTimer > 0) 
   {
     fill((min(30, messageTimer)/30.0)*255.0);

     text(messageText, 40, 50); 
   }
   
   display();
   text("Number of Friends: " + currentSelected.neighbors.size(), width-350, 60); 
   text("Average Speed of Flock: " + averageSpeed, width-350, 80); 
   text("Average Kinetic Energy of Flock: " + 0.5*0.075*averageSpeed, width-350, 100); 
   text("Direction of Flock: " + direction*180/PI, width-350, 120); 
   text("Speed: " + pow(pow(currentSelected.velocity.x,2) + pow(currentSelected.velocity.x,2) , 0.5), width-350, 140); 
   text("Kinetic Energy: " + 0.5*0.075*pow(pow(currentSelected.velocity.x,2) + pow(currentSelected.velocity.x,2) , 0.5), width-350, 160); 
   text("Press 'h' for help", width-350, 200);
}

/// returns the plural/singular "s"/"" based on count
String s(int count) 
{
  return (count != 1) ? "s" : "";
}

/// toggles on/off option's texts
String on(boolean in) 
{
  return in ? "on" : "off"; 
}

/// called when the mouse is pressed with a given place tool. performs the appropriate action
void mousePressed () 
{
  switch (placeTool) 
  {
    case "Starlings":
      starlings.add(new Starling(mouseX, mouseY));
      message(starlings.size() + " Total Starling" + s(starlings.size()));
      break;
    case "obstacles":
      boolean capsLocked = Toolkit.getDefaultToolkit().getLockingKeyState(KeyEvent.VK_CAPS_LOCK);
      obstacles.add(new Obstacle(mouseX, mouseY, capsLocked, 1.8));
      break;
    case "select":
      for(Starling starling: starlings)
      {
        if(pow(starling.position.x-mouseX,2) + pow(starling.position.y-mouseY,2) < 25)
        {
          averageSpeed = 0.0;
          direction = 0.0;
          currentSelected.select = false;
          currentSelected = starling;
          currentSelected.select = true;
          break;
        }
      }
   }
}

/// increase the maxSpeed on upward scrolling and decrease the maxSpeed on downward scrolling
void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  if(maxSpeed > 0.2*e)
  {
    maxSpeed -= 0.2*e;
  }
}

/// erases the starlings and voids within the eraseradius of the cursor
void erase () 
{
  for(int i=starlings.size()-1; i>-1; i--) 
  {
    Starling j = starlings.get(i);
    if(pow(j.position.x-mouseX, 2)+pow(j.position.y-mouseY, 2) < pow(eraseRadius,2)) 
    {
      starlings.remove(i);
    }
  }

  for (int i=obstacles.size()-1; i>-1; i--) {
    Obstacle j = obstacles.get(i);
    if (pow(j.position.x-mouseX, 2)+pow(j.position.y-mouseY, 2) < pow(eraseRadius,2)) 
    {
      obstacles.remove(i);
    }
  }
}

/// draw text on the window
void drawText (String s, float x, float y) 
{
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}

/// set the message text and the message timer for display info and stats
void message (String in) {
   messageText = in;
   messageTimer = (int) frameRate * 3;
}
