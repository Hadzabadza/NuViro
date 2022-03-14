Pop[] pops;

void setup() {
  size (1000, 1000);
  pops = new Pop[100];
  for (int i=0; i<pops.length; i++) pops[i] = new Pop(i);
}

void draw() {
  background(0);
  
  get_pop_near_mouse(mouseX, mouseY).draw_selected();
  stroke(255); 
  fill(255);
  for (Pop p : pops) p.draw();
}

Pop get_pop_near_mouse(float mousex, float mousey) {
  int pop_index = 0;
  float min_dist = dist(pops[0].pos.x, pops[0].pos.y, mousex, mousey);
  float dist;
  for (int i=1; i<pops.length; i++) {
    dist = dist(pops[i].pos.x, pops[i].pos.y, mousex, mousey);
    if (min_dist>dist) {
      min_dist = dist;
      pop_index = i;
    }
  }
  return pops[pop_index];
}
