import java.awt.Toolkit;
import java.awt.event.KeyEvent;

ArrayList<Boid> boids;
ArrayList<Avoid> avoids;
Boid currentSelected = new Boid(0.0,0.0);

float globalScale = .8;
float eraseRadius = 30;
String tool = "boids";
float averageSpeed;
double direction;

// boid control
float maxSpeed = 2.1 * globalScale;;
float friendRadius;
float crowdRadius = 20 + friendRadius / 1.3;
float avoidRadius;
float coheseRadius = friendRadius;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;
boolean option_lines = true;

// gui crap
int messageTimer = 0;
String messageText = "";

public void settings() {
  size(1800, 900);
}

void setup () {
  textSize(15);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  for (int x = 100; x < width - 100; x+= 100) {
    for (int y = 100; y < height - 100; y+= 100) {
      boids.add(new Boid(x + random(3), y + random(3)));
    }
  }
  
  setupWalls();
}

void recalculateConstants () {
  friendRadius = 50 * globalScale;
  avoidRadius = 150 * globalScale;
}


void setupWalls() 
{
  avoids = new ArrayList<Avoid>();
  for (int x = 40; x < width - 20; x+= 20) 
  {
    avoids.add(new Avoid(x, 20, true));
    avoids.add(new Avoid(x, height - 40, true));
  }
  for (int x = 20; x < height -20 ; x+= 20) 
  {
    avoids.add(new Avoid(20, x, true));
    avoids.add(new Avoid(width - 40, x, true));
  }
}

void setupCircle() 
{
  avoids = new ArrayList<Avoid>();
  for(int x = 0; x < 80; x+= 1) 
  {
    float dir = (x / 80.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.48, height * 0.5 + sin(dir)*height*.48, true));
  } 
  for(int x = 0; x < 64; x+= 1) 
  {
    float dir = (x / 64.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.32, height * 0.5 + sin(dir)*height*.32, true));
  } 
  for(int x = 0; x < 32; x+= 1) 
  {
    float dir = (x / 32.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.16, height * 0.5 + sin(dir)*height*.16, true));
  } 
  for(int x = 0; x < 16; x+= 1) 
  {
    float dir = (x / 16.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.08, height * 0.5 + sin(dir)*height*.08, true));
  } 
  for(int x = 0; x < 8; x+= 1) 
  {
    float dir = (x / 8.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.04, height * 0.5 + sin(dir)*height*.04, true));
  } 
}

void setupCourse()
{
  avoids = new ArrayList<Avoid>();
  for(int x = 12; x < 60; x+= 1) 
  {
    float dir = (x / 72.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.25 + cos(dir) * height*.3, height * 0.5 + sin(dir)*height*.3, true));
  } 
  for(int x = 0; x < 50; x+= 1) 
  {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.29, height * 0.5 + sin(dir)*height*.29, true));
  }
  for (int x = height/5 ; x < height * 0.8; x+= 25) 
  {
    avoids.add(new Avoid(width*0.73, x, true));
  }
  for(int x = 33; x < 68; x+= 1) 
  {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.78 + cos(dir) * height*.18, height * 0.35 + sin(dir)*height*.18, true));
  }
}

void randomize()
{
  for(int i = 0; i < boids.size(); i++)
  {
    Boid j = boids.get(i);
    j.pos.x = random(width);
    j.pos.y = random(height);
  }
}

void wind(int n)
{
  if(n == 0)
  {
    for(int i = 0; i < boids.size(); i++)
    {
      Boid j = boids.get(i);
      j.move.y -= 0.1;
    }
  }
  else if(n == 1)
  {
    for(int i = 0; i < boids.size(); i++)
    {
      Boid j = boids.get(i);
      j.move.x += 0.1;
    }
  }
  else if(n == 2)
  {
    for(int i = 0; i < boids.size(); i++)
    {
      Boid j = boids.get(i);
      j.move.y += 0.1;
    }
  }
  else if(n == 3)
  {
    for(int i = 0; i < boids.size(); i++)
    {
      Boid j = boids.get(i);
      j.move.x -= 0.1;
    }
  }
}

void cohese(boolean direction)
{
  if(direction)
  {
    coheseRadius += 10;
  }
  else
  {
    coheseRadius -= 10;
  }
}

void separation(boolean direction)
{
  if(direction)
  {
    crowdRadius += 10;
  }
  else
  {
    crowdRadius -= 10;
  }
}

void display(Boid Starling) 
{
  double directionY = 1.0;
  double directionX = 1.0;
  
  for(Boid starling: Starling.friends)
  {
    averageSpeed += pow(pow(starling.move.x,2) + pow(starling.move.x,2) , 0.5);
    directionX += starling.move.x;
    directionY += starling.move.y;
  }
  
  averageSpeed /= Starling.friends.size();
  direction = Math.atan(directionY/directionX);
 
}

void draw () 
{
  noStroke();
  colorMode(HSB);
  fill(0, 100);
  rect(0, 0, width, height);

  if (tool == "erase") 
  {
    noFill();
    stroke(0, 100, 200);
    rect(mouseX - eraseRadius, mouseY - eraseRadius, eraseRadius * 2.5, eraseRadius * 2.5);
    if (mousePressed) 
    {
      erase();
    }
  } 
  else if (tool == "avoids") 
  {
    noStroke();
    fill(100, 100, 200);
    ellipse(mouseX, mouseY, 25, 25);
  }
  
  for (int i = 0; i <boids.size(); i++) 
  {
    Boid current = boids.get(i);
    current.go();
    current.draw();
  }

  for (int i = 0; i <avoids.size(); i++) 
  {
    Avoid current = avoids.get(i);
    current.go();
    current.draw();
  }

  if (messageTimer > 0) 
  {
    messageTimer -= 1; 
  }
  drawGUI();
}

void keyPressed () {
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
    tool = "boids";
    message("Add boids");
  } 
  else if(key == 'w' || key == 'W') 
  {
    tool = "avoids";
    message("Place obstacles");
  } 
  else if(key == 'e' || key == 'E') 
  {
    tool = "erase";
    message("Eraser");
  } 
  else if(key == 'r' || key == 'R')
  {
    message("Randomized the Starlings");
    randomize();
  }
  else if(key == 's' || key == 'S')
  {
    tool = "select";
    message("Select Mode");
  }
  else if(key == 'z' || key == 'Z')
  {
    avoids = new ArrayList<Avoid>();
    message("Removed all avoids");
  }
  else if(key == 'x' || key == 'X')
  {
    boids = new ArrayList<Boid>();
    message("Removed all Starlings");
  }
  
  else if(key == '-') 
  {
    message("Decreased scale");
    globalScale *= 0.95;
  } 
  else if(key == '=') 
  {
    message("Increased Scale");
    globalScale /= 0.95;
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
     option_avoid = option_avoid ? false : true;
     message("Turned obstacle avoidance " + on(option_avoid));
  } 
  else if(key == '4')
  {
    separation(false);
    message("Decreased Separation");
  }
  else if(key == '5') {
     option_friend = option_friend ? false : true;
     message("Turned friend allignment " + on(option_friend));
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
     message("Turned crowding avoidance " + on(option_crowd));
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

  recalculateConstants();

}

void drawGUI() {
   if(messageTimer > 0) {
     fill((min(30, messageTimer) / 30.0) * 255.0);

     text(messageText, 50, 50); 
   }
   
   display(currentSelected);
   text("Number of Friends: " + currentSelected.friends.size(), width - 300, 50); 
   text("Average Speed of Flock: " + averageSpeed, width - 300, 70); 
   text("Average Kinetic Energy of Flock: " + 0.5 * 0.075 * averageSpeed, width - 300, 90); 
   text("Direction of Flock: " + direction * 180/PI, width - 300, 110); 
   text("Speed: " + pow(pow(currentSelected.move.x,2) + pow(currentSelected.move.x,2) , 0.5), width - 300, 130); 
   text("Kinetic Energy: " + 0.5 * 0.075 * pow(pow(currentSelected.move.x,2) + pow(currentSelected.move.x,2) , 0.5), width - 300, 150); 
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off"; 
}

void mousePressed () {
  switch (tool) {
  case "boids":
    boids.add(new Boid(mouseX, mouseY));
    message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case "avoids":
    boolean capsLocked = Toolkit.getDefaultToolkit().getLockingKeyState(KeyEvent.VK_CAPS_LOCK);
    avoids.add(new Avoid(mouseX, mouseY, capsLocked, 1.8));
    break;
  case "select":
    for(Boid starling: boids)
    {
      if(abs(starling.pos.x - mouseX) < 5 && abs(starling.pos.y) - mouseY < 5)
      {
        currentSelected.select = false;
        currentSelected = starling;
        currentSelected.select = true;
        break;
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(maxSpeed > 0.2 * e)
  {
    maxSpeed -= 0.2 * e;
  }
}

void erase () {
  for (int i = boids.size()-1; i > -1; i--) {
    Boid j = boids.get(i);
    if (abs(j.pos.x - mouseX) < eraseRadius && abs(j.pos.y - mouseY) < eraseRadius) {
      boids.remove(i);
    }
  }

  for (int i = avoids.size()-1; i > -1; i--) {
    Avoid j = avoids.get(i);
    if (abs(j.position.x - mouseX) < eraseRadius && abs(j.position.y - mouseY) < eraseRadius) {
      avoids.remove(i);
    }
  }
}

void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


void message (String in) {
   messageText = in;
   messageTimer = (int) frameRate * 3;
}
