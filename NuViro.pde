import java.util.HashMap;

Pop[] pops;
Pop selected;
Pathogen tester;
float delta_time=0;
float last_frame_time=0;
float update_timer_second=0;
float update_period = 20;

void setup() {
  size (1000, 1000);
  pops = new Pop[100];
  for (int i=0; i<pops.length; i++) pops[i] = new Pop(i);
  float[] tester_life_cycle_probs = {0.007, 0.006, 0.004, 0.007};
  int[] tester_repro_brackets = {2, 3};
  float[] tester_repro_probs = {0.005, 0.002};
  int[] tester_repro_destinations = {0, 0};
  tester = new Pathogen(3, "Tester", 4, tester_life_cycle_probs, tester_repro_brackets, tester_repro_probs, tester_repro_destinations);
}

void draw() {
  background(0);
  delta_time = millis()-last_frame_time;
  last_frame_time = millis();
  update_timer_second+=delta_time;

  if (update_timer_second>update_period) tester.process_infections();

  selected = get_pop_near_mouse(mouseX, mouseY);
  selected.draw_selected();
  stroke(255); 
  fill(255);
  for (Pop p : pops) p.draw();
  tester.draw();
  
  if (update_timer_second>update_period) update_timer_second-=update_period;
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

void keyReleased() {
  if (key==' ') tester.infect(selected);
}
