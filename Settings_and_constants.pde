float[] tropism_modifiers = {0.1, 0.25, 0.5, 1.0};
float update_period = 20;

public enum organ_type {

  TISSUE("Tissue", 300, 2000, 0), 
  BLOOD("Blood vessels", 200, 1200, 1), 
  BONES("Bones", 280, 1400, 2), 
  LYMPH("Lymphatic system", 200, 800, 3), 
  NEURAL("Neural system", 200, 800, 4), 
  BRAIN("Brain", 200, 400, 5), 
  EYES("Eyes", 100, 100, 6), 
  EARS("Ears", 100, 100, 7), 
  TONGUE("Tongue", 100, 100, 8), 
  LUNGS("Lungs", 150, 500, 9), 
  HEART("Heart", 150, 300, 10), 
  STOMACH("Stomach", 150, 400, 11), 
  LIVER("Liver", 150, 350, 12);

  final float health;
  final float volume;
  final String friendly_name;
  final int id;

  private organ_type(String _friendly_name, float _health, float _volume, int _id) {
    friendly_name = _friendly_name;
    health = _health;
    volume = _volume;
    id = _id;
  }
}

float [][] organ_adjacency_matrix = {
//          TISSUE BLOOD BONES LYMPH NEURAL BRAIN EYES  EARS  TONGUE LUNGS HEART STOMACH LIVER
/*TISSUE*/ {0.00,  0.80, 0.30, 0.50, 0.35,  0.00, 0.00, 0.05, 0.05,  0.20, 0.20, 0.20,   0.20},  
/*BLOOD*/  {0.90,  0.00, 0.40, 0.30, 0.10,  0.20, 0.70, 0.70, 0.60,  1.00, 1.00, 0.70,   0.85}, 
/*BONES*/  {0.50,  0.50, 0.00, 0.05, 0.05,  0.00, 0.00, 0.00, 0.00,  0.10, 0.05, 0.00,   0.00}, 
/*LYMPH*/  {0.60,  0.40, 0.20, 0.00, 0.30,  0.00, 0.00, 0.40, 0.40,  0.50, 0.30, 0.70,   0.80}, 
/*NEURAL*/ {0.80,  0.10, 0.10, 0.20, 0.00,  0.60, 0.90, 0.90, 0.80,  0.40, 0.50, 0.40,   0.40}, 
/*BRAIN*/  {0.10,  0.70, 0.10, 0.05, 1.00,  0.00, 0.05, 0.10, 0.05,  0.00, 0.00, 0.00,   0.00}, 
/*EYES*/   {0.10,  0.60, 0.05, 0.20, 0.40,  0.05, 0.00, 0.00, 0.00,  0.00, 0.00, 0.00,   0.00}, 
/*EARS*/   {0.10,  0.60, 0.05, 0.20, 0.40,  0.05, 0.00, 0.00, 0.00,  0.00, 0.00, 0.00,   0.00}, 
/*TONGUE*/ {0.10,  0.40, 0.05, 0.40, 0.10,  0.03, 0.00, 0.00, 0.00,  0.40, 0.00, 0.00,   0.00}, 
/*LUNGS*/  {0.40,  0.70, 0.10, 0.35, 0.15,  0.00, 0.00, 0.00, 0.25,  0.00, 0.05, 0.10,   0.05}, 
/*HEART*/  {0.60,  1.00, 0.15, 0.30, 0.30,  0.00, 0.00, 0.00, 0.00,  0.10, 0.00, 0.00,   0.00}, 
/*STOMACH*/{0.60,  0.40, 0.05, 0.40, 0.10,  0.00, 0.00, 0.00, 0.00,  0.05, 0.00, 0.00,   0.30}, 
/*LIVER*/  {0.60,  0.90, 0.00, 0.50, 0.10,  0.00, 0.00, 0.00, 0.00,  0.00, 0.00, 0.20,   0.00}};
