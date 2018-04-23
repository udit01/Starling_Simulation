/// the starling class defines starlings as objects
class Starling {
    /// vector representing position of the starling in the window 
    PVector position;
    /// vector representing velocity of the starling in the window 
    PVector velocity;
    /// float value holding the Red component of the color of the starling
    float colorR;
    /// float value holding the Green component of the color of the starling
    float colorG;
    /// float value holding the Blue component of the color of the starling
    float colorB;
    /// array of starlings that are within a friendly radius of this starling
    ArrayList<Starling> neighbors;
    /// whether the starling is selected or not to view its details
    boolean select = false;

    /// the thinking timer of the starling -- used in multi-threading  
    int decideTimer = 0;

    /// constructor of the class that takes two arguments i.e. the x-coordinate and y-coordinate of the starling
    Starling (float x, float y) 
    {
      velocity = new PVector(0, 0);
      position = new PVector(0, 0);
      position.x = x;
      position.y = y;
      decideTimer = int(random(10));
      colorR = random(255);
      colorG = random(255);
      colorB = random(255);
      neighbors = new ArrayList<Starling>();
    }

    /// just like an update function that runs every frame 
    void go () 
    {
      increment();
      wrap();

      if(decideTimer == 0 ) 
      {
        // update our friend array (lots of square roots)
        getNeighbors();
      }
    
      flock();
      position.add(velocity);
    }

    /// this function re-defines the velocity, color and neighbors of the starling based on the surroundings
    void flock() 
    {
      PVector alignment = getAverageDirection();
      PVector avoidCollision = getAvoidCollision(); 
      PVector oppositeObstacles = getOppositeObstacles();
      PVector noise = new PVector((random(2) - 1)/2, (random(2) -1)/2);
      PVector cohese = getCohesion();
      
      if(!option_neighbor)
      {
        alignment.mult(0);
      }
      if(!option_crowd)
      {
        avoidCollision.mult(0);
      }
      if(!option_obstacle)
      {
        oppositeObstacles.mult(0);
      }
      if(!option_noise)
      {
        noise.mult(0);
      }
      if(!option_cohese)
      {
        cohese.mult(0);
      }
      
      stroke(0, 255, 160);

      velocity.add(alignment);
      velocity.add(avoidCollision);
      velocity.add(oppositeObstacles.mult(3 *sqrt(velocity.x*velocity.x + velocity.y * velocity.y)));
      velocity.add(noise.mult(0.1));
      velocity.add(cohese);

      velocity.limit(maxSpeed);
      
      float[] colors = getAverageColor();
      
      colorR += colors[0] * 0.02;
      colorR = ((colorR) % 255 + 255) % 255;
      
      colorG += colors[1] * 0.02;
      colorG = ((colorG) % 255 + 255) % 255; 
      
      colorB += colors[2] * 0.02;
      colorB = ((colorB) % 255 + 255) % 255; 
    }
    
    /// updates the neighbors of the starling to those within a friendly radius
    void getNeighbors () 
    {
      ArrayList<Starling> near = new ArrayList<Starling>();

      for(int i=0; i<starlings.size(); i++) 
      {
        Starling s = starlings.get(i);
        if (s == this)
        { 
          continue;
        }
        if(pow((s.position.x - this.position.x),2) + pow((s.position.y - this.position.y),2) < pow(neighborRadius,2)) 
        {
           near.add(s);
        }
      }

      neighbors = near;
      System.out.println(neighbors.size());
    }

    /// updates the color of the starling to approximately the average of the neighbors 
    float[] getAverageColor () 
    {
      float totalColorR = 0.0;
      float totalColorG = 0.0;
      float totalColorB = 0.0;
      int count = neighbors.size();
      
      for(Starling s : neighbors) 
      {
        if (s.colorR - colorR < -128) 
        {
          totalColorR += s.colorR + 255 - colorR;
        } 
        else if (s.colorR - colorR > 128) 
        {
          totalColorR += s.colorR - 255 - colorR;
        } 
        else 
        {
          totalColorR += s.colorR - colorR; 
        }
        
        if (s.colorG - colorG < -128) 
        {
          totalColorG += s.colorG + 255 - colorG;
        } 
        else if (s.colorG - colorG > 128) 
        {
          totalColorG += s.colorG - 255 - colorG;
        } 
        else 
        {
          totalColorG += s.colorG - colorG; 
        }
        
        if (s.colorB - colorB < -128) 
        {
          totalColorB += s.colorB + 255 - colorB;
        } 
        else if (s.colorB - colorB > 128) 
        {
          totalColorB += s.colorB - 255 - colorB;
        } 
        else 
        {
          totalColorB += s.colorB - colorB; 
        }
          count ++;
      }

      if(count == 0) 
      {
        return (new float[]{0.0, 0.0, 0.0});
      }
      else
      {
        return (new float[]{totalColorR/(float)count, totalColorG/(float)count, totalColorB/(float)count});
      }
    }

    /// returns average direction vector of the neighbors normalized and inversely averaged with distance
    PVector getAverageDirection() 
    {
      PVector totalDirection = new PVector(0.0, 0.0);

      for(Starling s : neighbors) 
      {
          float distance = PVector.dist(this.position, s.position);

          if ((distance > 0) && (distance < neighborRadius)) 
          {
            PVector copy = s.velocity.copy();
            copy.normalize();
            copy.div(distance); 
            totalDirection.add(copy);
          }
      }

      return totalDirection;
    }

    /// returns average difference dispacement vector between this starling and the neighbors, normalized and inversely averaged with the distance
    PVector getAvoidCollision() 
    {
      PVector oppositeNeighbors = new PVector(0.0, 0.0);
  
      for(Starling s : neighbors) 
      {
        float distance = PVector.dist(this.position, s.position);
  
        if ((distance > 0) && (distance < crowdRadius)) 
        {
          PVector difference = PVector.sub(this.position, s.position);
          difference.normalize();
          difference.div(distance);
          oppositeNeighbors.add(difference);
        }
      }
      return oppositeNeighbors;
    }

    /// returns average opposite difference dispacement vector between this starling and the obstacles, normalized and inversely averaged with the distance
    PVector getOppositeObstacles() 
    {
      PVector oppositeObstacles = new PVector(0.0, 0.0);
        
      for (Obstacle o : obstacles) 
      {
        float distance = PVector.dist(this.position, o.position);
        if ((distance > 0) && (distance < obstacleRadius)) 
        {
          PVector difference = PVector.sub(this.position, o.position);
          difference.normalize();
          difference.div(distance);       
          oppositeObstacles.add(difference);
        }
      }
      return oppositeObstacles;
    }
  
    /// returns the average cohesion vector between this starling and those that are within the cohesion radius
    PVector getCohesion() 
    {
      PVector sum = new PVector(0.0, 0.0);   
      int count = 0;
  
      for(Starling s : neighbors) 
      {
        float distance = PVector.dist(this.position, s.position);
        if ((distance > 0) && (distance < coheseRadius)) 
        {
          sum.add(s.position); 
          count++;
        }
      }
  
      if (count == 0) 
      {
        return new PVector(0.0, 0.0);
      } 
      else 
      {
        sum.div(count);
        PVector required = PVector.sub(sum, this.position);  
        return required.setMag(0.05);
      }
    }

    /// pre-defined function that creates the visual apperance of the starling in the window
    void draw () 
    {
      int size = 1;
      for(int i=0; i<neighbors.size(); i++) 
      {
        Starling s = neighbors.get(i);
        stroke(90);
        if(!option_lines)
        {
          line(this.position.x, this.position.y, s.position.x, s.position.y);
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
      fill(colorR, colorG, colorB);
      pushMatrix();
      translate(position.x, position.y);
      rotate(velocity.heading());
      beginShape();
      vertex(18.75 * scale * size, 0 * size);                     // A
      vertex(15 * scale * size, 3 * scale * size);                // B
      vertex(6 * scale * size, 3 * scale * size);                 // E
      vertex(2.25 * scale * size, 12 * scale * size);             // F  
      vertex(-10 * scale * size, 15 * scale * size);              // G
      vertex(-1.125 * scale * size, 10.5 * scale * size);         // O
      vertex(1.5 * scale * size, 3 * scale * size);               // I
      vertex(-6 * scale * size, 3 * scale * size);                // J
      vertex(-22.5 * scale * size, 7.5 * scale * size);           // N      
      vertex(-9.375 * scale * size, 0 * size);                    // M
      vertex(-22.5 * scale * size, -7.5 * scale * size);          // L
      vertex(-6 * scale * size, -3 * scale * size);               // K
      vertex(1.5 * scale * size, -3 * scale * size);              // H
      vertex(-1.125 * scale * size, -10.5 * scale * size);        // R 
      vertex(-10 * scale * size, -15 * scale * size);             // Q
      vertex(2.25 * scale * size, -12 * scale * size);            // P
      vertex(6 * scale * size, -3 * scale * size);                // D
      vertex(15 * scale * size, -3 * scale * size);               // C 
      endShape(CLOSE);
      popMatrix();
    }

    /// this function runs every frame and updates the decide Timer
    void increment () 
    {
      decideTimer = (decideTimer + 1) % 5;
    }

    /// wraps the starling position to allow it to move across the whole window
    void wrap () 
    {
      position.x = (position.x + width) % width;
      position.y = (position.y + height) % height;
    }
}
