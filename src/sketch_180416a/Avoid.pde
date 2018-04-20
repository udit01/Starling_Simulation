class Avoid {
   PVector position;
   boolean shape;
   float size;
   
   Avoid (float xx, float yy, float zz, boolean shaped) 
   {
     position = new PVector(xx, yy, zz);
     shape = shaped;
     size = 1;
   }
   
   Avoid (float xx, float yy, float zz, boolean shaped, float n)
   {
     position = new PVector(xx, yy, zz);
     shape = shaped;
     size = n;
   }
   
   void go () {
     
   }
   
   void draw () {
     if(shape == true)
     {
       lights();
       pushMatrix();
       translate(width/2, height/2, 0);
       box(15);
       popMatrix();
     }
     else
     {
       ellipse(position.x, position.y, 14 * size, 14 * size);
     }
   }
}
