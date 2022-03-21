float ORGAN_TROPISM_MODIFIER_PRIMARY = 1;
float ORGAN_TROPISM_MODIFIER_SECONDARY = 0.5;
float ORGAN_TROPISM_MODIFIER_TERTIARY = 0.25;
float ORGAN_TROPISM_MODIFIER_TRANSITORY = 0.1;

class Pathogen {
  int type;
  String name;
  
  int life_cycle_states;
  float[] life_cycle_probs;
  
  int[] repro_brackets;
  float[] repro_probs;
  int[] repro_destinations;
  
  ArrayList<Infection> infections;
  HashMap<Organ, Float> tropism;
  HashMap<Organ, Float> trophism;

  Pathogen(
    int _type, 
    String _name, 
    int _life_cycle_states, 
    float [] _life_cycle_probs,
    int[] _repro_brackets,
    float[] _repro_probs,
    int[] _repro_destinations) 
  {
    type = _type;
    name = _name;
    life_cycle_states = _life_cycle_states;
    life_cycle_probs = _life_cycle_probs;
    repro_brackets = _repro_brackets;
    repro_probs = _repro_probs;
    repro_destinations = _repro_destinations; 
    infections = new ArrayList<Infection>();
  }

  //Pathogen(
  //  int _type, 
  //  String _name, 
  //  int _life_cycle_states, 
  //  float [] _life_cycle_probs, 
  //  HashMap<Organ, Float> _tropism, 
  //  HashMap<Organ, Float> _trophism) 
  //{
  //  type = _type;
  //  name = _name;
  //  life_cycle_states = _life_cycle_states;
  //  life_cycle_probs = _life_cycle_probs;
  //  infections = new ArrayList<Infection>();
  //  tropism =  _tropism;
  //  trophism = _trophism;
  //}
  
  void infect(Pop target){
    float infection_strength = 0.05;
    Organ o = target.organs[round(random(-0.49,organ_type.values().length))];
    float infection_volume = o.current_volume*infection_strength;
    Infection i = new Infection(this, o, 0, infection_volume);
    infections.add(i);
    target.infections.add(i);
    o.occupy_volume(infection_volume);
  }

  void process_infections() {
    for (Infection i : infections) i.update();
  }
  void draw(){
    for (Infection i : selected.infections) i.draw(50,50);
  }
}
