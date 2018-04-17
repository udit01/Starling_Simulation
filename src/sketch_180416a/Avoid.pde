class Avoid {
   PVector position;
   boolean shape;
   float size;
   
   Avoid (float xx, float yy, boolean zz) 
   {
     position = new PVector(xx,yy);
     shape = zz;
     size = 1;
   }
   
   Avoid (float xx, float yy, boolean zz, float n)
   {
     position = new PVector(xx,yy);
     shape = zz;
     size = n;
   }
   
   void go () {
     
   }
   
   void draw () {
     fill(255, 0, 200);
     if(shape == true)
     {
       rect(position.x, position.y, 14 * size, 14 * size, 3 * size);
     }
     else
     {
       ellipse(position.x, position.y, 14 * size, 14 * size);
     }
   }
}
