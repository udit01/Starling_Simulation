/// the obstacle class defines objects that the starlings cannot pass through i.e it defines obstacles
class Obstacle {
   /// the position vector (x, y) of the obstacle in the window
   PVector position;
   /// decides the shape of the obstacle. can be rectangular or circular.
   boolean shape;
   /// scale of the obstacle dimensional size
   float size;
   
   /// constructor of the class obstacle. takes three arguments , the x coordinate of the obstacle, the y coordinate of the obstacle and the shape boolean value
   Obstacle (float x, float y, boolean shaped) 
   {
     position = new PVector(x, y);
     shape = shaped;
     size = 1;
   }
   
   /// constructor of the class obstacle. takes three arguments , the x coordinate of the obstacle, the y coordinate of the obstacle, the shape boolean value and the dimension scale
   Obstacle (float x, float y, boolean shaped, float n)
   {
     position = new PVector(x, y);
     shape = shaped;
     size = n;
   }
   
   /// pre-defined function that creates the visual apperance of the obstacle in the window
   void draw () 
   
   {
     fill(255, 0, 200);
     
     if(shape == true)
     {
       rect(position.x, position.y, 14*size, 14*size, 3*size);
     }
     else
     {
       ellipse(position.x, position.y, 14*size, 14*size);
     }
   }
}
