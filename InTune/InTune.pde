//Caspar Lant and Eliza Hripcsak
//InTune

import themidibus.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

MidiBus bus; 
int sinFreq;
int controllerNum;
Minim minim;
AudioOutput out;
Oscil sinwave;
Oscil triwave;
Oscil sqrwave;
MoogFilter  moog;
int[] knobs = new int[100]; //change length later

//Notes: 
//Any note can be found by running the operation (note*10^octave)
//The octave of the notes shown is 0, middle-c is C4
final float C  = 16.35; //32.70, 65.41, 130.8, 261.6, and so on
final float Cs = 17.32; //wooo, CS!
final float Df = 17.32;
final float D  = 18.35;
final float Ds = 19.45;
final float Ef = 19.45;
final float E  = 20.60;
final float F  = 21.83;
final float Fs = 23.12;
final float Gf = 23.12;
final float G  = 24.50;
final float Gs = 25.96;
final float Af = 25.96;
final float A  = 27.50;
final float As = 29.14;
final float Bf = 29.14;
final float B  = 30.87;

final float[] chromFreqs = {
  65.41, 69.30, 73.42, 77.78, 82.41, 
  87.31, 92.50, 98.00, 103.8, 110.0, 
  116.5, 123.5, 130.8, 138.6, 146.8, 
  155.6, 164.8, 174.6, 185.0, 196.0, 
  207.7, 220.0, 233.1, 246.9,
};

final float[] keys = {Af, A, As, Bf, B, C, Cs, Df, D, F, Fs, Gf, G, Gs};

void setup() {
  size(1280, 800);
  background(0);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  bus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  minim = new Minim(this);
  out = minim.getLineOut();
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  sinwave = new Oscil( 0, 1.8f, Waves.SINE );  
  triwave = new Oscil( 0, 2f, Waves.TRIANGLE );
  
  // patch the Oscil to the output
  sinwave.patch(out);
  triwave.patch(out);
}


void draw() {
  //sinwave.setFrequency(sinFreq*2 + 70);
  //triwave.setFrequency((sinFreq + 80)/2);
  sinwave.setFrequency(chromFreqs[knobs[16]/6] + 1);
  triwave.setFrequency((chromFreqs[knobs[17]/6] + 1)/2);
  //sinwave.setFrequency(cM[sinFreq/18]*8);
  //triwave.setFrequency(cM[sinFreq/18]*4);
  //background(controllerNum*5, sinFreq*2, 100);
  background(0);
  stroke( 255 );
  //stroke(255 - controllerNum*5, 255 - sinFreq*2, 155); //changes w freq
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i+=10 )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0 , out.bufferSize(), 0, width );
    line(x1, 450 + out.right.get(i)*100, x2,250 + out.right.get(i+1)*100);
  } 
} 

void noteOn(int channel, int pitch, int velocity) {
  println("Note On: " + pitch + " @ " + velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  println("Note Off: " + pitch + " @ " + velocity);
}

void controllerChange(int channel, int number, int value) {
  println("C: " + number + " @ " + value);
  knobs[number] = value;
}

void stop()
{
  out.close();
  minim.stop(); 
  super.stop();
}

