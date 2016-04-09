/*
* Drives up to 6 solenoids plugged (via MOSFETs)
* on outputs D2 to D7
*/
int output=0;

void setup() {
  Serial.begin(115200);
  DDRD = DDRD | B11111100;
}

void loop() {
  if (Serial.available() > 0) {
     //read data from Serial
     output = (Serial.read() << 2);
     //quick I/O driving on PORTD
     PORTD = (PORTD & output) | (PORTD & B11);
     PORTD |= output | (PORTD & B11);
  }
}
