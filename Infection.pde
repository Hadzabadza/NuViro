class Infection {
  Pathogen pathogen; 
  Pop host;
  HashMap<Organ, LocalInfection> local_infections;

  //SortedMap<Organ, float[]> pathogen_pool;

  Infection(Pathogen blueprint, Organ target, int starting_bracket, float quantity) {
    local_infections = new HashMap<Organ, LocalInfection>();
    pathogen = blueprint;
    host = target.body;
    infect_organ(target, starting_bracket, quantity);
  }

  void infect_organ(Organ target, int bracket, float quantity) {
    if (!local_infections.containsKey(target)) local_infections.put(target, new LocalInfection(this, target, bracket, quantity)); 
    else local_infections.get(target).adjust_pop(bracket, quantity);
  }

  void update() {
    for (LocalInfection inf : local_infections.values()) inf.update();
  }

  void draw(int x, int y) {
    if (selected == host) {
      String infection_stats;
      float[] pool;
      int offset = 0;
      for (Organ o : local_infections.keySet()) {
        infection_stats = ""+o.name+": "+String.format("%.0f", 100*o.current_volume/o.max_volume)+"%";
        pool = local_infections.get(o).age_brackets;
        for (int i=0; i<pool.length; i++) infection_stats+=" "+String.format("%.0f", pool[i]);
        text(infection_stats, x, y+20*offset);
        offset++;
      }
    }
  }
}

class LocalInfection {
  Pathogen pathogen;
  Infection infection; 
  Organ host_organ;
  float[] age_brackets;
  float temp_adjuster;

  LocalInfection(Infection parent_infection, Organ _host_organ, int target_bracket, float quantity) {
    infection = parent_infection;
    pathogen = infection.pathogen;
    host_organ = _host_organ;
    age_brackets = new float[pathogen.life_cycle_states];
    for (int i=0; i<age_brackets.length; i++) age_brackets[i]=0;
    adjust_pop(target_bracket, quantity);
  }

  void update() {
    float agers=0;
    float newgens=0;
    //Ded    
    adjust_pop(age_brackets.length-1, -age_brackets[age_brackets.length-1]*pathogen.life_cycle_probs[age_brackets.length-1]*random(0.5, 1.5));

    //Aging
    for (int i = age_brackets.length-1; i>0; i--) {
      agers = age_brackets[i-1]*(pathogen.life_cycle_probs[i-1]*random(0.5, 1.5));
      adjust_pop(i-1, -agers);
      adjust_pop(i, agers);
    }

    //Newborns
    for (int i = 0; i<pathogen.repro_brackets.length; i++) {
      newgens = age_brackets[pathogen.repro_brackets[i]]*(pathogen.repro_probs[i]*random(0.5, 1.5));
      adjust_pop(pathogen.repro_destinations[i], newgens);
    }
  }

  void adjust_pop(int bracket, float quantity) {
    temp_adjuster = min(host_organ.current_volume, quantity);
    age_brackets[bracket]=max(age_brackets[bracket]+temp_adjuster, 0);
    host_organ.current_volume= min(host_organ.current_volume-temp_adjuster, host_organ.max_volume);
  }
}
