class Boid {
  // main fields
  PVector pos;
  PVector move;
  float colorx;
  float colory;
  float colorz;
  ArrayList<Boid> friends;
  boolean select = false;

  // timers
  int thinkTimer = 0;


  Boid (float xx, float yy) {
    move = new PVector(0, 0);
    pos = new PVector(0, 0);
    pos.x = xx;
    pos.y = yy;
    thinkTimer = int(random(10));
    colorx = random(255);
    colory = random(255);
    colorz = random(255);
    friends = new ArrayList<Boid>();
  }

  void go () {
    increment();
    wrap();

    if (thinkTimer ==0 ) {
      // update our friend array (lots of square roots)
      getFriends();
    }
    flock();
    pos.add(move);
  }

  void flock () {
    PVector allign = getAverageDir();
    PVector avoidDir = getAvoidDir(); 
    PVector avoidObjects = getAvoidAvoids();
    PVector noise = new PVector((random(2) - 1)/2, (random(2) -1)/2);
    PVector cohese = getCohesion();

    allign.mult(1);
    if (!option_friend) allign.mult(0);
    
    avoidDir.mult(1);
    if (!option_crowd) avoidDir.mult(0);
    
    avoidObjects.mult(3);
    if (!option_avoid) avoidObjects.mult(0);

    noise.mult(0.1);
    if (!option_noise) noise.mult(0);

    cohese.mult(1);
    if (!option_cohese) cohese.mult(0);
    
    
    
    stroke(0, 255, 160);

    move.add(allign);
    move.add(avoidDir);
    move.add(avoidObjects.mult(sqrt(move.x*move.x + move.y * move.y)));
    move.add(noise);
    move.add(cohese);

    move.limit(maxSpeed);
    
    colorx += getAverageColorX() * 0.02;
    colorx = (colorx + 255) % 255;
    
    colory += getAverageColorY() * 0.02;
    colory = (colory + 255) % 255; 
    
    colorz += getAverageColorZ() * 0.02;
    colorz = (colorz + 255) % 255; 
  }

  void getFriends () {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid test = boids.get(i);
      if (test == this) continue;
      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius) {
        nearby.add(test);
      }
    }
    friends = nearby;
  }

  float getAverageColorX () {
    float total = 0;
    float count = 0;
    
    for (Boid other : friends) 
    {
      if (other.colorx - colorx < -128) 
      {
        total += other.colorx + 255 - colorx;
      } 
      else if (other.colorx - colorx > 128) 
      {
        total += other.colorx - 255 - colorx;
      } 
      else 
      {
        total += other.colorx - colorx; 
      }
      count++;
    }
    if (count == 0) return 0;
    return total / (float) count;
  }
  
  float getAverageColorY () {
    float total = 0;
    float count = 0;
    
    for (Boid other : friends) 
    {
      if (other.colory - colory < -128) 
      {
        total += other.colory + 255 - colory;
      } 
      else if (other.colory - colory > 128) 
      {
        total += other.colory - 255 - colory;
      } 
      else 
      {
        total += other.colory - colory; 
      }
      count++;
    }
    if (count == 0) return 0;
    return total / (float) count;
  }
  
  float getAverageColorZ () {
    float total = 0;
    float count = 0;
    
    for (Boid other : friends) 
    {
      if (other.colorz - colorz < -128) 
      {
        total += other.colorz + 255 - colorz;
      } 
      else if (other.colorz - colorz > 128) 
      {
        total += other.colorz - 255 - colorz;
      } 
      else 
      {
        total += other.colorz - colorz; 
      }
      count++;
    }
    if (count == 0) return 0;
    return total / (float) count;
  }

  PVector getAverageDir () 
  {
    PVector sum = new PVector(0, 0);

    for (Boid other : friends) 
    {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < friendRadius)) 
      {
        PVector copy = other.move.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
      }
    }
    return sum;
  }

  PVector getAvoidDir() 
  {
    PVector steer = new PVector(0, 0);

    for (Boid other : friends) 
    {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < crowdRadius)) 
      {
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
      }
    }
    return steer;
  }

  PVector getAvoidAvoids() 
  {
    PVector steer = new PVector(0, 0);
    for (Avoid other : avoids) 
    {
      float d = PVector.dist(pos, other.position);
      if ((d > 0) && (d < avoidRadius)) 
      {
        PVector diff = PVector.sub(pos, other.position);
        diff.normalize();
        diff.div(d);       
        steer.add(diff);
      }
    }
    return steer;
  }
  
  PVector getCohesion () {
    PVector sum = new PVector(0, 0);   
    int count = 0;
    for (Boid other : friends) 
    {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < coheseRadius)) 
      {
        sum.add(other.pos); 
        count++;
      }
    }
    if (count > 0) 
    {
      sum.div(count);
      PVector desired = PVector.sub(sum, pos);  
      return desired.setMag(0.05);
    } 
    else 
    {
      return new PVector(0, 0);
    }
  }

  void draw () {
    int size = 1;
    for ( int i = 0; i < friends.size(); i++) {
      Boid f = friends.get(i);
      stroke(90);
      if(!option_lines)
      {
        line(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
      }
    }
    if(select)
    {
      size = 2;
    }
    else
    {
      size = 1;
    }
    noStroke();
    fill(colorx, colory, colorz);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(move.heading());
    beginShape();
    vertex(18.75 * globalScale * size, 0 * size);                           // A
    vertex(15 * globalScale * size, 3 * globalScale * size);                // B
    vertex(6 * globalScale * size, 3 * globalScale * size);                 // E
    vertex(2.25 * globalScale * size, 12 * globalScale * size);             // F  
    vertex(-10 * globalScale * size, 15 * globalScale * size);              // G
    vertex(-1.125 * globalScale * size, 10.5 * globalScale * size);         // O
    vertex(1.5 * globalScale * size, 3 * globalScale * size);               // I
    vertex(-6 * globalScale * size, 3 * globalScale * size);                // J
    vertex(-22.5 * globalScale * size, 7.5 * globalScale * size);           // N      
    vertex(-9.375 * globalScale * size, 0 * size);                          // M
    vertex(-22.5 * globalScale * size, -7.5 * globalScale * size);          // L
    vertex(-6 * globalScale * size, -3 * globalScale * size);               // K
    vertex(1.5 * globalScale * size, -3 * globalScale * size);              // H
    vertex(-1.125 * globalScale * size, -10.5 * globalScale * size);        // R 
    vertex(-10 * globalScale * size, -15 * globalScale * size);             // Q
    vertex(2.25 * globalScale * size, -12 * globalScale * size);            // P
    vertex(6 * globalScale * size, -3 * globalScale * size);                // D
    vertex(15 * globalScale * size, -3 * globalScale * size);               // C 
    endShape(CLOSE);
    popMatrix();
  }

  void mouseOver() 
  {

    background(200,200,200);

  }

  // update all those timers!
  void increment () {
    thinkTimer = (thinkTimer + 1) % 5;
  }

  void wrap () {
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }
}
