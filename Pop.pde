class Pop {
  int id;
  PVector pos;
  PVector scale; 
  
  Pop(int _id) {
    id = _id;
    pos = new PVector (random(0, width), random(0, height));
    scale = new PVector (10, 10);
  }

  void update() {
    wander();
  }

  void draw() {
    update();
    ellipse(pos.x, pos.y, scale.x, scale.y);
  }
  
  void draw_selected(){
    stroke(0,255,0);
    noFill();
    ellipse(pos.x, pos.y, scale.x*2, scale.y*2);
  }

  void wander() {
    float xrand = random (-1, 1);
    float yrand = random (-1, 1);
    if (((pos.x + xrand)<width)&&((pos.x + xrand)>0)) pos.x+=xrand;
    if (((pos.y + yrand)<height)&&((pos.y + yrand)>0)) pos.y+=yrand;
  }
}