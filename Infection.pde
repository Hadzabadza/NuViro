class Infection {
  Pathogen pathogen; 
  Pop host;
  HashMap<Organ, float[]> pathogen_pool;

  Infection(Pathogen blueprint, Organ target, float quantity) {
    pathogen = blueprint;
    host = target.body;
    initiate_infection();
    pathogen_pool.get(target)[0] = quantity;
  }

  void initiate_infection() {
    pathogen_pool = new HashMap<Organ, float[]>();
    for (Organ o : host.organs) 
    {
      pathogen_pool.put(o, new float[pathogen.life_cycle_states]);
      for (int i=0; i<pathogen_pool.size(); i++) {
        float[] pool = pathogen_pool.get(o);
        for (int j=0; j<pool.length; j++) pool[j]=0;
      }
    }
  }

  void update() {
    float agers = 0;
    for (float[] p : pathogen_pool.values()) {
      for (int i = p.length-1; i>0; i--) {
        agers = p[i-1]*(1-pathogen.life_cycle_probs[i-1]);
        p[i-1]-=agers;
        p[i]+=agers;
      }
      p[p.length-1]*=pathogen.life_cycle_probs[p.length-1];
    }
  }

  void draw(int x, int y) {
    if (selected == host) {
      String infection_stats;
      float[] pool;
      int offset = 0;
      for (Organ o : pathogen_pool.keySet()) {
        infection_stats = ""+o.name+":";
        pool = pathogen_pool.get(o);
        for (int i=0; i<pool.length; i++) infection_stats+=" "+String.format("%.2f", pool[i]);
        text(infection_stats, x, y+20*offset);
        offset++;
      }
    }
  }
}
