class Infection {
  Pathogen pathogen; 
  Pop host;
  HashMap<Organ, LocalInfection> local_infections;
  HashMap<Organ, LocalInfection> nufections;
  float _adjuster;
  float _transferrer;

  Infection(Pathogen blueprint, Organ target, int starting_bracket, float quantity) {
    local_infections = new HashMap<Organ, LocalInfection>();
    nufections = new HashMap<Organ, LocalInfection>();
    pathogen = blueprint;
    host = target.body;
    infect_organ(target, starting_bracket, quantity);
  }

  float infect_organ(Organ target, int bracket, float quantity) {
    LocalInfection linf;
    if (!local_infections.containsKey(target)) 
    {
      linf = new LocalInfection(this, target);
      nufections.put(target, linf);
      _adjuster = linf.adjust_pop(bracket, quantity);
    } else
    {
      linf = local_infections.get(target);
      _adjuster = linf.adjust_pop(bracket, quantity);
    }
    return _adjuster;
  }

  float transfer_to_organ(LocalInfection from, Organ to, int bracket, float quantity) {
    _transferrer = from.adjust_pop(bracket, -quantity)*-1;
    infect_organ(to, bracket, _transferrer);
    _transferrer-=_adjuster;
    if (_transferrer>0) from.adjust_pop(bracket, _transferrer);
    return _adjuster;
  }

  void update() {
    for (LocalInfection linf : local_infections.values()) linf.update();
    if (nufections.size()>0) {
      local_infections.putAll(nufections);
      nufections.clear();
    }
  }

  void draw(int x, int y) {
    if (selected == host) {
      String infection_stats;
      float[] pool;
      int offset = 0;
      for (Organ o : local_infections.keySet()) {
        infection_stats = ""+o.name+": "+String.format("%.0f", 100*o.volume_ratio)+"%";
        pool = local_infections.get(o).age_brackets;
        for (int i=0; i<pool.length; i++) infection_stats+=" "+String.format("%.2f", pool[i]);
        infection_stats+=" "+String.format("%.3f", local_infections.get(o)._tropism_adjustment);
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
  float tropism;
  float tropism_sq;

  float _adjuster;
  float _transferrer;
  float _agers;
  float _newgens;
  float _organ_migration_sum;
  float _migrants;
  float _random_distrib;
  float _tropism_adjustment;

  LocalInfection(Infection parent_infection, Organ _host_organ) {
    infection = parent_infection;
    pathogen = infection.pathogen;
    host_organ = _host_organ;

    age_brackets = new float[pathogen.life_cycle_states];
    for (int i=0; i<age_brackets.length; i++) age_brackets[i]=0;
    tropism = pathogen.tropism.get(host_organ.type);
    tropism_sq = pow(tropism, 2);

    _organ_migration_sum = 0;
    for (float f : host_organ.connection_map.values()) _organ_migration_sum += f;
  }

  void update() {

    _random_distrib = random(0.5, 1.5);
    //_tropism_adjustment = 1-max(1-pow((1/tropism)*host_organ.volume_ratio, 3), 0);
    _tropism_adjustment = max(1-(host_organ.volume_parabolic_ratio_component/tropism_sq), 0);

    //Ded    
    adjust_pop(age_brackets.length-1, -age_brackets[age_brackets.length-1]*pathogen.life_cycle_probs[age_brackets.length-1]*_random_distrib*debug_mortality_modifier);

    //Migrating
    migrate();

    //Aging
    for (int i = age_brackets.length-1; i>0; i--) {
      _agers = age_brackets[i-1]*(pathogen.life_cycle_probs[i-1]*_random_distrib*debug_mortality_modifier);
      adjust_pop(i-1, -_agers);
      adjust_pop(i, _agers);
    }

    //Newborns
    for (int i = 0; i<pathogen.repro_brackets.length; i++) {
      _newgens = age_brackets[pathogen.repro_brackets[i]]*(pathogen.repro_probs[i]*_tropism_adjustment*_random_distrib);
      //_newgens = age_brackets[pathogen.repro_brackets[i]]*(pathogen.repro_probs[i]*_random_distrib);
      adjust_pop(pathogen.repro_destinations[i], _newgens);
    }
  }

  void migrate() {
    //floor(x+0.5)*pow(2*x-1,2);
    //float active_migration_push_coefficient=pow(host_organ.current_volume/host_organ.max_volume, 2);
    float active_migration_push_coefficient=1-_tropism_adjustment;
    for (int i=0; i<age_brackets.length; i++) {
      //Drifters
      _migrants = age_brackets[i]*pathogen.migration_probs[i][0];
      //Active migrants
      _migrants += age_brackets[i]*pathogen.migration_probs[i][1]*active_migration_push_coefficient;
      for (Organ o : host_organ.connection_map.keySet()) 
        infection.transfer_to_organ(this, o, i, _migrants*host_organ.connection_map.get(o));
    }
  }

  float adjust_pop(int target_bracket, float quantity) {
    _adjuster = host_organ.adjust_occupied_volume(quantity);
    age_brackets[target_bracket]+=_adjuster;
    return _adjuster;
  }
}
