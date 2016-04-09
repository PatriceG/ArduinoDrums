/*
* Reads MIDI nodeOn & noteOff incoming messages and
* forwards them through Serial port as an Arduino PORTD byte value suitable for fast I/O on PORTD.
*/
import themidibus.*;
import processing.serial.*;

//Arduino COM Port
String serialPortName = "COM11";

//Name of the virtual MIDI port as displayed by RTPMidi (based on the actual computer name)
String midiPortName = "OAB-R90B40D8";

//if true then this sketch sends a series of cyclic on/off pulses to all outputs without using MIDI
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


