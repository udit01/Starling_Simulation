class Obstacle {
   PVector position;
   boolean shape;
   float size;
   
   Obstacle (float x, float y, boolean shaped) 
   {
     position = new PVector(x, y);
     shape = shaped;
     size = 1;
   }
   
   Obstacle (float x, float y, boolean shaped, float n)
   {
     position = new PVector(x, y);
     shape = shaped;
     size = n;
   }
   
   void go () 
   {
     
   }
   
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
