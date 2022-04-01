class Organ {
  Pop body;
  
  float max_health;
  float current_health;
  float health_ratio;
  
  float max_volume;
  float current_volume;
  float occupied_volume;
  float volume_ratio=1.0;
  float volume_parabolic_ratio_component=1.0; 
  
  organ_type type;
  String name; 
  HashMap<Organ, Float> connection_map;

  float _adjuster;

  Organ(organ_type _type, Pop _body) {
    type = _type;
    max_health = type.health;
    current_health = max_health;
    max_volume = type.volume;
    current_volume = max_volume;
    name = type.friendly_name;
    body = _body;
    update();
  }
  
  void connect_organs(HashMap<organ_type, Organ> _organs){
    connection_map = new HashMap<Organ, Float>();
    for (int i=0; i<organ_adjacency_matrix.length; i++)
      if (organ_adjacency_matrix[type.id][i] > 0.00) 
        connection_map.put(_organs.get(organ_type.values()[i]), organ_adjacency_matrix[type.id][i]);
  }

  float adjust_occupied_volume(float _volume) {
    _adjuster = min(max_volume-current_volume+_volume, min(current_volume, _volume));
    //_adjuster = _volume;
    occupied_volume+=_adjuster;
    current_volume-=_adjuster;
    return _adjuster;
  }

  void adjust_health(float _health) {
    if (_health+current_health>max_health) current_health = max_health;
    else if (_health+current_health<0) current_health = 0;
    else current_health += _health;
    current_volume = max_volume*(current_health/max_health);
  }
  
  void update(){
    health_ratio = current_health/max_health;
    volume_ratio = current_volume/max_volume;
    volume_parabolic_ratio_component = pow(1-volume_ratio,2);
  }
}
