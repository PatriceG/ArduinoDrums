/*
* Lit les messages midi nodeOn & noteOff entrants et
* les faits suivre sous forme d'un octet de commande du PORTD de l'Arduino
* via le port série
*/
import themidibus.*;
import processing.serial.*;

//Port COM sur lequel écoute l'Arduino
String serialPortName = "COM11";

//Nom du port MIDI virtuel tel qu'affiché dans RTPMidi
String midiPortName = "OAB-R90B40D8";

//si true alors ce sketch envoie une série de notes de façon cyclique et n'utilise pas le MIDI
boolean DEBUG=false;

Serial serialPort; 
int msg,note,velocity;    
int noteMin = 60;
int outputPort = 0;
MidiBus myBus; 
int it=0;

void setup() 
{
  frameRate(100);
  size(1, 1);

  serialPort = new Serial(this, serialPortName, 115200);
  
  MidiBus.list();
  if(DEBUG){
    midiPortName = "LoopBe Internal MIDI";
    frameRate(2);
  }
  
  myBus = new MidiBus(this, midiPortName, -1);
}

void send(boolean noteOn, int pitch){
  int solenoid = pitch-noteMin;
  if(solenoid >= 0 && solenoid <= 6){
      if(noteOn){
        outputPort = outputPort | (1 << solenoid);
      }else{
        outputPort = outputPort & ~(1 << solenoid);
      }
      serialPort.write(outputPort);
      if(DEBUG){
        println(outputPort);
      }
  }
}

void noteOn(int channel, int pitch, int velocity) {
  println ("On: " + pitch+" ,vel: "+velocity);
  if(velocity > 0)
    send(true,pitch);
  else
    send(false,pitch);
}

void noteOff(int channel, int pitch, int velocity) {
  println("Off: " + pitch);
  send(false,pitch);
}

  
void draw()
{
 if(DEBUG){
   send(true,noteMin+(it % 6));
   delay(50);
   send(false,noteMin+(it % 6));
   it++;
 }
}


