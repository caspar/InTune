//Caspar Lant and Eliza Hripcsak
//InTune 
import java.util.*;
import controlP5.*;
import themidibus.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

MidiBus bus; 
int sinFreq;
int controllerNum;
int tempo = 120;
int beat = 0;
Minim minim;
AudioOutput out;
MoogFilter moog;
Midi2Hz midi;
Oscil       wave;
Wavetable   table;

boolean record = false;
boolean play = false;

int[] knobs = new int[100]; //change length later
Knob a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q//, r, s, t, u, v, w, x, y, z
;

Knob[] guiKnobs = {
  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q//, r, s, t, u, v, w, x, y, z
};
String[] knobNames = {
  "OSCA Freq", "OSCB Freq", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Tempo"
};

int[] noteBank = new int[16*2]; //2 is # of measures

ControlP5 cp5;
double[] scale;
int mode;
int keyOf;
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
  println(knobNames.length);
  size(1280, 758);
  background(0);
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  bus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
  minim = new Minim(this);
  out = minim.getLineOut();
  cp5 = new ControlP5(this);
  setScale(0, 0);
  midi    = new Midi2Hz( 50 );
  
  table = WavetableGenerator.gen9(4096, new float[] { 1, 2 }, new float[] { 1, 1 }, new float[] { 0, 0 });
  table.addNoise(.05);
  wave  = new Oscil( 220, 0.5f, table );
  // patch the Oscil to the output
  wave.patch( out );
  
  //create knobs
  for (int i = 0; i < 16; i++) {
    guiKnobs[i] = cp5.addKnob(knobNames[i] +" "+ (i+1)+" ")
      .setRange(0, 127)
        .setPosition(80*(i % 8)+10, height-(90*(i/8+1)))
          .setRadius(30)
            .setDragDirection(Knob.VERTICAL)
              .setDecimalPrecision(0)
                .shuffle()
                  .setShowAngleRange(false)
                    ;
  }
  guiKnobs[guiKnobs.length-1] = cp5.addKnob("tempo")
    .setRange(40, 300)
      .setRadius(30)
        .setDragDirection(Knob.VERTICAL)
          .setDecimalPrecision(0)
            .setValue(tempo)
              .setShowAngleRange(false)
                .setPosition(970, height-180)
                  ;

  Toggle record = cp5.addToggle("record")
    .setPosition(1050, 717);
  Bang clear = cp5.addBang("clear")
    .setPosition(1105, 717)
      .setSize(40, 20);
  Bang play = cp5.addBang("play")
    .setPosition(1160, 717)
      .setSize(40, 20);
  Bang stopPlay = cp5.addBang("stop")
    .setPosition(1215, 717)
      .setSize(40, 20);
      
  stroke(255);
  rect(100,100,100,100);

  // create a ListBox for mode
  ListBox d1 = cp5.addListBox("Mode");
  d1.setPosition(1050, 580);
  customize(d1);
  d1.addItem("Ionian", 0);
  d1.addItem("Dorian", 1);
  d1.addItem("Phrygian", 2);
  d1.addItem("Lydian", 3);
  d1.addItem("Mixolydian", 4);
  d1.addItem("Aeolian", 5);
  d1.addItem("Locrian", 6);
  d1.addItem("Chromatic", 7);

  Textlabel keyLabel = cp5.addTextlabel("Key Label")
    .setPosition(1050, 516)
      .setSize(15, 100)
        .setText("CHOOSE A KEY");

  RadioButton r1 = cp5.addRadioButton("Key")
    .setPosition(1050, 529)
      .setSize(10, 15)
        .setItemsPerRow(7)
          .setSpacingColumn(20)
            .setColorLabel(color(255));
  r1.addItem("Af", 0);
  r1.addItem("A", 1);
  r1.addItem("As", 2);
  r1.addItem("Bf", 3);
  r1.addItem("B", 4);
  r1.addItem("C", 5);
  r1.addItem("Cs", 6);
  r1.addItem("Df", 7);
  r1.addItem("D", 8);
  r1.addItem("F", 9);
  r1.addItem("Fs", 10);
  r1.addItem("Gf", 11);  
  r1.addItem("G", 12);
  r1.addItem("Gs", 13);
}

void customize(ListBox ddl) {
  ddl.setSize(200, 200);
  ddl.setItemHeight(15);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("choose a mode");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  //doesn't actually show you which is selected
  ddl.setColorActive(color(255, 128));
}
  Waveform disWave = Waves.sawh( 4 );

void keyPressed()
{
  //the way this is written means what any key not listed plays the last note but i guess that's not a huge problem
  if ( key == 'a' ) {
    midi.setMidiNoteIn( 50 );
    if (record) noteBank[beat] = (50);
  }
  if ( key == 's' ) {
    midi.setMidiNoteIn( 52 );
    if (record) noteBank[beat] = (52);
  }
  if ( key == 'd' ) {
    midi.setMidiNoteIn( 54 );
    if (record) noteBank[beat] = (54);
  }
  if ( key == 'f' ) {
    midi.setMidiNoteIn( 55 );
    if (record) noteBank[beat] = (55);
  }
  if ( key == 'g' ) {
    midi.setMidiNoteIn( 57 );
    if (record) noteBank[beat] = (57);
  }
  if ( key == 'h' ) {
    midi.setMidiNoteIn( 59 );
    if (record) noteBank[beat] = (59);
  }
  if ( key == 'j' ) {
    midi.setMidiNoteIn( 61 );
    if (record) noteBank[beat] = (61);
  }
  if ( key == 'k' ) {
    out.playNote( 0.0, 1.0, new TheWave( "E4 ", 2, disWave, out ) );
    midi.setMidiNoteIn( 62 );
    if (record) noteBank[beat] = (50);
  }
  if ( key == 'l' ) {
    midi.setMidiNoteIn( 64 );
    if (record) noteBank[beat] = (64);
  }
  if ( key == ';' ) {
    midi.setMidiNoteIn( 66 );
    if (record) noteBank[beat] = (66);
  }
  if ( key == '\'') {
    midi.setMidiNoteIn( 67 );
    if (record) noteBank[beat] = (67);
  }
  if ( key == 'm') {
    println("Knobs: " + Arrays.toString(knobs));
    println("SinFreq: " + chromFreqs[knobs[0]/6] + 1);
  }
  //noteBank[beat] = (midi.getLastValues()[0]);
  println(Arrays.toString(noteBank));
}

void setScale(int mode, int keyOf) {
  //modes are 0-6
  //[I D P L M A L]
  //[Ionian Dorian Phyrigian Lydian Mixolydian Aeolian Locrian]
  final int[] Ionian = {
    2, 2, 1, 2, 2, 2, 1
  }; //these numbers represent how much we should increment by
  int[] steps = new int[7];
  scale = new double[7];
  //for (int i = mode ; i != mode - 1; i++){
  int j;
  for (int i = 0; i < 7; i++) {
    j = (i + mode) % 7; 
    steps[i] = Ionian[j];
  }
  //i think the key is supposed to have something to do with this??
  //but i don't really know where it goes  
  int keyCount = keyOf;
  int scaleCount = 0;
  for (int s : steps) {
    keyCount += steps[s];
    keyCount = keyCount % keys.length;
    scale[scaleCount] = keys[keyCount];
    scaleCount++;
  }
}

void draw() {
  for (int i = 0; i < guiKnobs.length; i++) {
    knobs[i] = (int)guiKnobs[i].getValue();
  }

  wave.setFrequency((float)knobs[0]/3);
  background(0);
  stroke(255);
  for ( int i = 0; i < out.bufferSize() - 1; i+=10 )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    line(x1, 450 + out.right.get(i)*100, x2, 250 + out.right.get(i+1)*100);
  }  
} 

void record(boolean flag) {
  record = flag;
}

void clear() {
  for (int i = 0 ; i < noteBank.length; i++)
    noteBank[i] = 0;
}

void noteOn(int channel, int pitch, int velocity) {
  println("Note On: " + pitch + " @ " + velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  println("Note Off: " + pitch + " @ " + velocity);
}

void controlEvent(ControlEvent theEvent) {
  // if the event is from a group, which is the case with the ListBox
  if (theEvent.isGroup()) {
    if (theEvent.group().name().equals("Mode")) {
      mode = (int)theEvent.group().value();
    } else if (theEvent.group().name().equals("Key")) {
      keyOf = (int)theEvent.group().value();
    }
    setScale(mode, keyOf);
    //println(Arrays.toString(scale));
  } else if (theEvent.isController()) {
    //i don't know what this is but apparently it's supposed to be here
    //shouldn't this already be covered by controllerChange?
    //or is that just when physical knobs are moved
    //wait do we need this here for the knobs to do anything by themselves
  }
}

void controllerChange(int channel, int number, int value) {
  println("CC: " + number + " @ " + value);
  knobs[number-16] = value;
  //if (number >= 15 && number <= 32)
  guiKnobs[number-16].setValue(value);
}

void stop()
{
  out.close();
  minim.stop(); 
  super.stop();
}

