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
  
  LinkedHashMap<organ_type, Float> tropism;
  LinkedHashMap<organ_type, Float> trophism;
  
  
  LinkedHashMap<Pop, Infection> infections;

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
    infections = new LinkedHashMap<Pop, Infection>();
  }

  //Pathogen(
  //  int _type, 
  //  String _name, 
  //  int _life_cycle_states, 
  //  float [] _life_cycle_probs, 
  //  LinkedHashMap<organ_type, Float> _tropism, 
  //  LinkedHashMap<organ_type, Float> _trophism) 
  //{
  //  type = _type;
  //  name = _name;
  //  life_cycle_states = _life_cycle_states;
  //  life_cycle_probs = _life_cycle_probs;
  //  infections = new ArrayList<Infection>();
  //  tropism =  _tropism;
  //  trophism = _trophism;
  //}
  
  void infect(Organ target, int target_bracket, float quantity){
    Infection i = target.body.infect_with_pathogen(this, target, target_bracket, quantity);
    infections.put(target.body,i);
    target.body.infections.put(this, i);
  }

  void process_infections() {
    for (Infection inf : infections.values()) inf.update();
  }
  void draw(){
    //for (Infection i : selected.infections.values()) i.draw(50,50);
  }
}
