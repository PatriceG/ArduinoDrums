/*
* Pilote jusqu'à 6 solénoides branchés
* sur les sorties D2 à D7
*/
int output=0;

void setup() {
  Serial.begin(115200);
  DDRD = DDRD | B11111100;
}

void loop() {
  if (Serial.available() > 0) {
     //lecture état du port souhaité
     output = (Serial.read() << 2);
     //pilotage rapide du PORTD
     PORTD = (PORTD & output) | (PORTD & B11);
     PORTD |= output | (PORTD & B11);
  }
}
