//Caspar Lant and Eliza Hripcsak
//InTune

import themidibus.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

MidiBus bus; 
int sinFreq;
Minim minim;
AudioOutput out;
Oscil sinwave;
Oscil triwave;
Oscil sqrwave;

//Notes: 
//Any note can be found by running the operation (note*10^octave)
//The octave of the notes shown is 0, middle-c is C4
float C  = 16.35; //32.70, 65.41, 130.8, 261.6, and so on
float Cs = 17.32;
float Df = 17.32;
float D  = 18.35;
float Ds = 19.45;
float Ef = 19.45;
float E  = 20.60;
float F  = 21.83;
float Fs = 23.12;
float Gf = 23.12;
float G  = 24.50;
float Gs = 25.96;
float Af = 25.96;
float A  = 27.50;
float As = 29.14;
float Bf = 29.14;
float B  = 30.87;

float[] chromFreqs = {
  65.41, 69.30, 73.42, 77.78, 82.41, 
  87.31, 92.50, 98.00, 103.8, 110.0, 
  116.5, 123.5, 130.8, 138.6, 146.8, 
  155.6, 164.8, 174.6, 185.0, 196.0, 
  207.7, 220.0, 233.1, 246.9,
};

float[] aM  = {};
float[] am  = {};
float[] bfM = { Bf, C, D, Ef, F, G, A };
float[] bfm = {};
float[] bM  = {};
float[] bm  = {};
float[] cM  = { C, D, E, F, G, A, B, C*2.0 };
float[] cm  = {};
float[] csM = {};
float[] csm = {};
float[] dfM = {};
float[] dfm = {};
float[] dM  = {};
float[] dm  = {};
float[] dsM = {};
float[] dsm = {};
float[] efM = {};
float[] efm = {};
float[] eM  = {};
float[] em  = {};
float[] fM  = {};
float[] fm  = {};
float[] fsM = {};
float[] fsm = {};
float[] gfM = {};
float[] gfm = {};
float[] gM  = {};
float[] gm  = {};
float[] gsM = {};
float[] gsm = {};
float[] afM = {};
float[] afm = {};

void setup() {
  size(1280, 800);
  background(0);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  bus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  minim = new Minim(this);
  out = minim.getLineOut();
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  sinwave = new Oscil( 0, 0.8f, Waves.SINE );  
  triwave = new Oscil( 0, 1f, Waves.TRIANGLE );
  sqrwave = new Oscil( 220, 0.01f, Waves.SQUARE );

  // patch the Oscil to the output
  sinwave.patch(out);
  triwave.patch(out);
  //sqrwave.patch(out);
}

void draw() {
  //sinwave.setFrequency(sinFreq + 80);
  //triwave.setFrequency((sinFreq + 80)/2);
  //sinwave.setFrequency(chromFreqs[sinFreq/6] + 1);
  //triwave.setFrequency((chromFreqs[sinFreq/6] + 1)/2);
  sinwave.setFrequency(cM[sinFreq/18]*8);
} 

//void colorPixels(int pitch, int ) {
//  background(
//}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  //println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  //colorPixels(pitch, velocity)
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  //println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  //println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  background(number*5, value*2, 100);
  sinFreq = value;
  if (number == 14){
     sinFreq = 0;
    background(0);
  }
}

