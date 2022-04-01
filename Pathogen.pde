class Pathogen {
  int type;
  String name;

  int life_cycle_states;
  float[] life_cycle_probs;

  int[] repro_brackets;
  float[] repro_probs;
  int[] repro_destinations;

  float[][] migration_probs;

  HashMap<organ_type, Float> tropism;
  HashMap<organ_type, Float> trophism;


  LinkedHashMap<Pop, Infection> infections;

  Pathogen(
    int _type, 
    String _name, 
    int _life_cycle_states, 
    float [] _life_cycle_probs, 
    int[] _repro_brackets, 
    float[] _repro_probs, 
    int[] _repro_destinations, 
    float[][] _migration_probs, 
    HashMap<organ_type, Float> _tropism) 
  {
    type = _type;
    name = _name;
    life_cycle_states = _life_cycle_states;
    life_cycle_probs = _life_cycle_probs;
    repro_brackets = _repro_brackets;
    repro_probs = _repro_probs;
    repro_destinations = _repro_destinations; 
    migration_probs = _migration_probs;
    tropism = _tropism;
    build_tropism_map();

    infections = new LinkedHashMap<Pop, Infection>();
  }

  void build_tropism_map() {
    int tropism_modifier_id; 
    HashMap<organ_type, Float> tropism_map = new HashMap<organ_type, Float>();
    for (organ_type o : tropism.keySet()) {
      tropism_map.put(o, 1.0);
      for (int i=0; i<organ_adjacency_matrix[o.id].length; i++) {
        tropism_modifier_id = max(floor(log2(organ_adjacency_matrix[o.id][i]*16)), 1)-1;
        if (tropism_map.get(organ_type.values()[i]) == null) {
          tropism_map.put(organ_type.values()[i], tropism_modifiers[tropism_modifier_id]);
        } else {
          if (tropism_modifiers[tropism_modifier_id] > tropism_map.get(organ_type.values()[i])) 
            tropism_map.put(organ_type.values()[i], tropism_modifiers[tropism_modifier_id]);
        }
      }
    }
    tropism = tropism_map;
  }

  void infect(Organ target, int target_bracket, float quantity) {
    Infection i = target.body.infect_with_pathogen(this, target, target_bracket, quantity);
    infections.put(target.body, i);
    target.body.infections.put(this, i);
  }

  void process_infections() {
    for (Infection inf : infections.values()) inf.update();
  }

  void draw() {
    //for (Infection i : selected.infections.values()) i.draw(50,50);
    String tropism_info;
    int y = 20;
    int offset = 0;
    text("Tropism info:", 20, y+20*offset);
    for (organ_type o : tropism.keySet()) {
      offset++;
      text(o.friendly_name+ ": " + tropism.get(o), 20, y+20*offset);
    }
  }
}
