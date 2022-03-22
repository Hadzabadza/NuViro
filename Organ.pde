public enum organ_type {

  TISSUE("Tissue", 200, 2000), 
    BLOOD("Blood vessels", 100, 1200), 
    LYMPH("Lymphatic system", 100, 800), 
    NEURAL("Neural system", 100, 800), 
    BRAIN("Brain", 200, 400), 
    EYES("Eyes", 100, 100), 
    EARS("Ears", 100, 100), 
    TONGUE("Tongue", 100, 100), 
    LUNGS("Lungs", 100, 500), 
    HEART("Heart", 100, 300), 
    STOMACH("Stomach", 100, 400), 
    LIVER("Liver", 100, 350);

  final float health;
  final float volume;
  final String friendly_name;

  private organ_type(String _friendly, float _health, float _volume) {
    friendly_name = _friendly;
    health = _health;
    volume = _volume;
  }
}

class Organ {
  Pop body;
  float max_health;
  float current_health;
  float max_volume;
  float current_volume;
  float occupied_volume;
  int type;
  String name; 

  float _adjuster;

  Organ(organ_type type, Pop _body) {
    max_health = type.health;
    current_health = max_health;
    max_volume = type.volume;
    current_volume = max_volume;
    name = type.friendly_name;
    body = _body;
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
}
