class Avoid {
   PVector pos;
   
   Avoid (float xx, float yy) {
     pos = new PVector(xx,yy);
   }
   
   void go () {
     
   }
   
   void draw () {
     fill(255, 0, 200);
     ellipse(pos.x, pos.y, 16, 16);
   }
}
