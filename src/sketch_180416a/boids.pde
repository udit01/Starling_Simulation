Boid barry;
ArrayList<Boid> boids;
ArrayList<Avoid> avoids;

float globalScale = .8;
float eraseRadius = 30;
String tool = "boids";

// boid control
float maxSpeed;
float friendRadius;
float crowdRadius;
float avoidRadius;
float coheseRadius;

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
  for (int x = 100; x < width - 100; x+= 200) {
    for (int y = 100; y < height - 100; y+= 200) {
      boids.add(new Boid(x + random(3), y + random(3)));
      boids.add(new Boid(x + random(3), y + random(3)));
      boids.add(new Boid(x + random(3), y + random(3)));
    }
  }
  
  setupWalls();
}

void recalculateConstants () {
  maxSpeed = 2.1 * globalScale;
  friendRadius = 60 * globalScale;
  crowdRadius = (friendRadius / 1.3);
  avoidRadius = 90 * globalScale;
  coheseRadius = friendRadius;
}


void setupWalls() 
{
  avoids = new ArrayList<Avoid>();
  for (int x = 20; x < width; x+= 20) 
  {
    avoids.add(new Avoid(x, 10));
    avoids.add(new Avoid(x, height - 10));
  }
  for (int x = 20; x < height; x+= 20) 
  {
    avoids.add(new Avoid(10, x));
    avoids.add(new Avoid(width - 10, x));
  }
}

void setupCircle() 
{
  avoids = new ArrayList<Avoid>();
  for(int x = 0; x < 80; x+= 1) 
  {
    float dir = (x / 80.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.48, height * 0.5 + sin(dir)*height*.48));
  } 
  for(int x = 0; x < 64; x+= 1) 
  {
    float dir = (x / 64.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.32, height * 0.5 + sin(dir)*height*.32));
  } 
  for(int x = 0; x < 32; x+= 1) 
  {
    float dir = (x / 32.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.16, height * 0.5 + sin(dir)*height*.16));
  } 
  for(int x = 0; x < 16; x+= 1) 
  {
    float dir = (x / 16.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.08, height * 0.5 + sin(dir)*height*.08));
  } 
  for(int x = 0; x < 8; x+= 1) 
  {
    float dir = (x / 8.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.04, height * 0.5 + sin(dir)*height*.04));
  } 
}

void setupCourse()
{
  avoids = new ArrayList<Avoid>();
  for(int x = 12; x < 60; x+= 1) 
  {
    float dir = (x / 72.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.25 + cos(dir) * height*.3, height * 0.5 + sin(dir)*height*.3));
  } 
  for(int x = 0; x < 50; x+= 1) 
  {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.29, height * 0.5 + sin(dir)*height*.29));
  }
  for (int x = height/5 ; x < height * 0.8; x+= 25) 
  {
    avoids.add(new Avoid(width*0.73, x));
  }
  for(int x = 33; x < 68; x+= 1) 
  {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.78 + cos(dir) * height*.18, height * 0.35 + sin(dir)*height*.18));
  }
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
  if (key == 'q') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'w') {
    tool = "avoids";
    message("Place obstacles");
  } else if (key == 'e') {
    tool = "erase";
    message("Eraser");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.9;
  } else if (key == '=') {
      message("Increased Scale");
    globalScale /= 0.9;
  } else if (key == '1') {
     option_friend = option_friend ? false : true;
     message("Turned friend allignment " + on(option_friend));
  } else if (key == '2') {
     option_crowd = option_crowd ? false : true;
     message("Turned crowding avoidance " + on(option_crowd));
  } else if (key == '3') {
     option_avoid = option_avoid ? false : true;
     message("Turned obstacle avoidance " + on(option_avoid));
  } else if (key == '4') {
     option_cohese = option_cohese ? false : true;
     message("Turned cohesion " + on(option_cohese));
  } else if (key == '5') {
     option_noise = option_noise ? false : true;
     message("Turned noise " + on(option_noise));
  } else if (key == '6') {
     option_lines = option_lines ? false : true;
     message("Turned interactions " + on(option_lines));
  } else if (key == ',') {
     setupWalls(); 
  } else if (key == '.') {
     setupCircle(); 
  } else if(key == '/') {
     setupCourse();
  }
  recalculateConstants();

}

void drawGUI() {
   if(messageTimer > 0) {
     fill((min(30, messageTimer) / 30.0) * 255.0);

    text(messageText, 10, height - 20); 
   }
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
    avoids.add(new Avoid(mouseX, mouseY));
    break;
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
    if (abs(j.pos.x - mouseX) < eraseRadius && abs(j.pos.y - mouseY) < eraseRadius) {
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
