class Pop {
  int id;
  PVector pos;
  PVector scale;
  color c;
  HashMap<organ_type, Organ> organs;
  HashMap<Pathogen, Infection> infections;

  Pop(int _id) {
    id = _id;
    pos = new PVector (random(0, width), random(0, height));
    scale = new PVector (10, 10);
    init_organs();
    infections = new LinkedHashMap<Pathogen, Infection>();
    c = color(255);
  }

  private void init_organs() {
    organs = new HashMap <organ_type, Organ>();
    for (int i = 0; i<organ_type.values().length; i++) organs.put(organ_type.values()[i], new Organ(organ_type.values()[i], this));
    for (Organ o:organs.values()) o.connect_organs(organs);
  }

  Infection infect_with_pathogen(Pathogen blueprint, Organ target, int target_bracket, float quantity) {
    c = color(255, 0, 0);
    if (!infections.containsKey(blueprint)) infections.put(blueprint, new Infection(blueprint, target, target_bracket, quantity));
    else infections.get(blueprint).infect_organ(target, target_bracket, quantity);
    return infections.get(blueprint);
  }
  
  Organ get_random_organ(){
    int target=round(random(-0.49, organs.size()-0.51));
    int i=0;
    for (Organ o:organs.values()) {
      if (i==target) return o;
      else i++;
    }
    return null;
  }
  
  void update() {
    wander();
  }

  void draw() {
    update(); 
    fill(c);
    ellipse(pos.x, pos.y, scale.x, scale.y);
  }

  void draw_selected() {
    stroke(0, 255, 0); 
    noFill(); 
    ellipse(pos.x, pos.y, scale.x*2, scale.y*2);
    fill(255);
    for (Infection inf : infections.values()) inf.draw(round(pos.x)+10, round(pos.y));
  }

  void wander() {
    float xrand = random (-1, 1); 
    float yrand = random (-1, 1); 
    if (((pos.x + xrand)<width)&&((pos.x + xrand)>0)) pos.x+=xrand; 
    if (((pos.y + yrand)<height)&&((pos.y + yrand)>0)) pos.y+=yrand;
  }
}
