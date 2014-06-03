//Caspar Lant and Eliza Hripcsak
//InTune 
import controlP5.*;
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
MoogFilter moog;
Midi2Hz midi;
ADSR  adsr;



int[] knobs = new int[100]; //change length later
Knob a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;

Knob[] guiknobs = {
  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p
};

ControlP5 cp5;
double[] scale;
int[] colors = {
  #FF0000, #00FF00, #0000FF
};

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

final float[] keys = {
  Af, A, As, Bf, B, C, Cs, Df, D, F, Fs, Gf, G, Gs
};

void setup() {
  size(1280, 758);
  background(0);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  bus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  minim = new Minim(this);
  out = minim.getLineOut();
  cp5 = new ControlP5(this);
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  sinwave = new Oscil( 0, 1.8f, Waves.SINE );  
  triwave = new Oscil( 0, 2f, Waves.TRIANGLE );
  moog    = new MoogFilter( 1200, 0.5 );
  midi    = new Midi2Hz( 50 );
  //ADSR(float maxAmp, float attTime, float decTime, float susLvl, float relTime) 
  adsr    = new ADSR( 0.1, 0.3, 0.2, 0.00, 0.01 );
  midi.patch(sinwave.frequency);
  midi.patch(triwave.frequency);
  //sinwave.patch(moog).patch( out );
  // patch the Oscil to the output
  triwave.patch(adsr);
  sinwave.patch(adsr);
  for (int i = 0; i < guiknobs.length; i++) {
    guiknobs[i] = cp5.addKnob(""+i)
      .setRange(0, 127)
        .setPosition(80*i+10, height-90)
          .setRadius(30)
            .setDragDirection(Knob.VERTICAL)
              .setDecimalPrecision(0)
                .shuffle()
                  .setShowAngleRange(false)
                    ;
    guiknobs[i].setLabel(""+"knob "+guiknobs[i].getName());
  }
}

void keyPressed()
{
  if ( key == 'a' ) midi.setMidiNoteIn( 50 );
  if ( key == 's' ) midi.setMidiNoteIn( 52 );
  if ( key == 'd' ) midi.setMidiNoteIn( 54 );
  if ( key == 'f' ) midi.setMidiNoteIn( 55 );
  if ( key == 'g' ) midi.setMidiNoteIn( 57 );
  if ( key == 'h' ) midi.setMidiNoteIn( 59 );
  if ( key == 'j' ) midi.setMidiNoteIn( 61 );
  if ( key == 'k' ) midi.setMidiNoteIn( 62 );
  if ( key == 'l' ) midi.setMidiNoteIn( 64 );
  if ( key == ';' ) midi.setMidiNoteIn( 66 );
  if ( key == '\'') midi.setMidiNoteIn( 67 );
  if ( key == '1' ) moog.type = MoogFilter.Type.LP;
  if ( key == '2' ) moog.type = MoogFilter.Type.HP;
  if ( key == '3' ) moog.type = MoogFilter.Type.BP;
  adsr.noteOn();
  adsr.patch( out );
}

void getScale(int mode, int keyOf) {
  //returns scale
  //modes are 0-6
  //[I D P L M A L]
  //[Ionian Dorian Phyrigian Lydian Mixolydian Aeolian Locrian]
  final int[] Ionian = {
    2, 2, 1, 2, 2, 2, 1
  }; //these numbers represent how much we should increment by
  int[] steps = new int[7];
  scale = new double[7];
  //for (int i = mode ; i != mode - 1; i++){
  int ii;
  for (int i = 0; i < 7; i++) {
    ii = (i + mode) % 7; 
    steps[i] = Ionian[ii];
  }
  //update: this is literally exactly what you did sorry caspie
  int count = 0;
  for (int s : steps) {
    count += steps[s];
    scale[s] = chromFreqs[s];
  }
}

void draw() {
  //sinwave.setFrequency((float)knobs[16]*2 + 70);
  //triwave.setFrequency((float)(knobs[17] + 80)/2);
  sinwave.setFrequency(chromFreqs[knobs[16]/6] + 1);
  triwave.setFrequency((chromFreqs[knobs[17]/6] + 1)/2);
  sinwave.setAmplitude((float)knobs[24]/63 + 0.01);
  triwave.setAmplitude((float)knobs[25]/63 + 0.01);

  moog.frequency.setLastValue((float)knobs[18]*20 );
  moog.resonance.setLastValue((float)knobs[26]/127  );

  //sinwave.setFrequency(cM[sinFreq/18]*8);
  //triwave.setFrequency(cM[sinFreq/18]*4);
  background(0);
  //stroke(colors[(int)random(3)]);
  stroke(255);
  for ( int i = 0; i < out.bufferSize() - 1; i+=10 )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    line(x1, 450 + out.right.get(i)*100, x2, 250 + out.right.get(i+1)*100);
  }  
  text( "Filter type: " + moog.type, 10, 225 );
  text( "Filter cutoff: " + moog.frequency.getLastValue() + " Hz", 10, 245 );
  text( "Filter resonance: " + moog.resonance.getLastValue(), 10, 265 );
} 

void noteOn(int channel, int pitch, int velocity) {
  println("Note On: " + pitch + " @ " + velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  println("Note Off: " + pitch + " @ " + velocity);
}

void controllerChange(int channel, int number, int value) {
  println("CC: " + number + " @ " + value);
  knobs[number] = value;
}

void stop()
{
  out.close();
  minim.stop(); 
  super.stop();
}

