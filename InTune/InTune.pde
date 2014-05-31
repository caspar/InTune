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

final float[] keys = {Ab, A, As, Bf, B, C, Cs, Df, D, F, Fs, Gf, G, Gs};
    //GCDBEAD -- circle of 5ths

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
  sinwave = new Oscil( 0, 1.8f, Waves.SINE );  
  triwave = new Oscil( 0, 2f, Waves.TRIANGLE );
  sqrwave = new Oscil( 220, 0.01f, Waves.SQUARE );

  // patch the Oscil to the output
  sinwave.patch(out);
  triwave.patch(out);
  //sqrwave.patch(out);
  
  //Pasted:
  //moog    = new MoogFilter( 1200, 0.5 );
  
  // we will filter a white noise source,
  // which will allow us to hear the result of filtering
  //Noise noize = new Noise( 0.5f );  

  // send the noise through the filter
  //noize.patch( moog ).patch( out );
}
double[] getScale(int mode, int keyOf){
  //returns scale
  //modes are 1-7
  //[I D P L M A L]
  //[Ionian Dorian Phyrigian Lydian Mixolydian Aeolian Locrian]
  final int[] Ionian = {2,2,1,2,2,2,1}; //these numbers represent how much we should increment by
  int[] steps = new int[7];
  double[] scale = new double[7];
  //for (int i = mode ; i != mode - 1; i++){
  int i = mode; 
  while (steps[7] != null){//for each? while steps.hasNext()?
      if (i == 6) i = 0;
      steps[]
      i++;
  }
  i = 0;
  for (int j : steps){
     i+=steps[j];
     scale[i] = chromFreqs[i];
  }
  return scale;
}

void draw() {
  //sinwave.setFrequency(sinFreq*2 + 70);
  //triwave.setFrequency((sinFreq + 80)/2);
  sinwave.setFrequency(chromFreqs[sinFreq/6] + 1);
  triwave.setFrequency((chromFreqs[sinFreq/6] + 1)/2);
  //sinwave.setFrequency(cM[sinFreq/18]*8);
  //triwave.setFrequency(cM[sinFreq/18]*4);
  //background(controllerNum*5, sinFreq*2, 100);
  background(0);
 //stroke( 255 );
 stroke(255 - controllerNum*5, 255 - sinFreq*2, 155);
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i+=10 )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0 , out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    //line( x1, 280 + out.left.get(i)*100, x2, 250 + out.left.get(i+1)*100);
    line(x1, 450 + out.right.get(i)*100, x2,250 + out.right.get(i+1)*100);
  } 
  
  //text( "Filter type: " + moog.type, 10, 225 );
  //text( "Filter cutoff: " + moog.frequency.getLastValue() + " Hz", 10, 245 );
  //text( "Filter resonance: " + moog.resonance.getLastValue(), 10, 265 ); 

} 
void keyPressed()
{
  if ( key == '1' ) moog.type = MoogFilter.Type.LP;
  if ( key == '2' ) moog.type = MoogFilter.Type.HP;
  if ( key == '3' ) moog.type = MoogFilter.Type.BP;
}
void mouseMoved()
{
  float freq = constrain( map( mouseX/10, 0, width, 200, 12000 ), 200, 12000 );
  float rez  = constrain( map( mouseY/10, height, 0, 0, 1 ), 0, 1 );
  
  //moog.frequency.setLastValue( freq );
  //moog.resonance.setLastValue( rez  );
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
  sinFreq = value;
  controllerNum = number;
  if (number == 14){
     sinFreq = 0;
    background(0);
  }
}

void stop()
{
  out.close();
  minim.stop(); 
  super.stop();
}

