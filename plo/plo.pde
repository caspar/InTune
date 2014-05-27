// plo a Step sequencer Synth
// developped by damary
// author: gef@ponnuki.net
// april 30th, 2010
// version 0.2
// ponnuki.net
 
import controlP5.*;
ControlP5 controlP5;
import beads.*;
 
AudioContext ac;
Glide carrierFreq, modFreqRatio;
 
WavePlayer wp;
WavePlayer wp2;
 
Knob myKnobA;
Knob myKnobB;
Knob myKnobC;
Knob myKnobD;
Knob myKnobE;
Knob myKnobF;
 
Gain g,g2;
 
void setup() {
  size(600,600);
  frameRate(10);
  smooth();
 
  /******************** THE GUI *******************************/
 
 
 
  controlP5 = new ControlP5(this);
  // The 2 matrix
  controlP5.addMatrix("topMatrix", 33, 15, 10, 10, 400, 300);
  controlP5.addMatrix("baseMatrix", 16, 5, 10, 350, 400, 100);
  // The 5 knobs
  myKnobA = controlP5.addKnob("knob",0,0.5,0,480,100,80);
  myKnobB = controlP5.addKnob("knobValueB",0,1,0,460,180,40);
  myKnobE = controlP5.addKnob("knobValueE",0,2000,0,540,180,40);
  myKnobD = controlP5.addKnob("knobValueD",0,3,0,460,320,40);
  myKnobC = controlP5.addKnob("knobValueC",0,0.5,0,480,360,80);
 
 
  /********************THE AUDIO SYNTH *************************/
 
  ac = new AudioContext();
 
  /////////// Creating the top synth
  carrierFreq = new Glide(ac, 5);
  modFreqRatio = new Glide(ac, 1);
 
  Function modFreq = new Function(carrierFreq, modFreqRatio) {
    public float calculate() {
      return x[0] * x[1];
    }
  };
  WavePlayer freqModulator2 = new WavePlayer(ac, modFreq, Buffer.SINE);
  Function carrierMod = new Function(freqModulator2, carrierFreq) {
    public float calculate() {
      return x[0] * 50.0 + x[1];
    }
  };
  wp = new WavePlayer(ac, carrierMod, Buffer.SINE);
 
  g = new Gain(ac, 1, 0);
  g.addInput(wp);
  ac.out.addInput(g);
 
  ////// Creating the bottom synth
  WavePlayer freqModulator = new WavePlayer(ac, 50, Buffer.SINE);
  Function function = new Function(freqModulator) {
    public float calculate() {
      return x[0] * 100.0 + 600.0;
    }
  };
 
  wp2 = new WavePlayer(ac, function, Buffer.SINE);
 
  g2 = new Gain(ac, 1, 0);
  g2.addInput(wp2);
  ac.out.addInput(g2);
 
  ac.start();
  frameRate(30);
}
 
color fore = color(95,151,180);
 
void draw() {
  background(0);
   
  wave(); //display the waves
 
  /// 3 knobs for the top synth
  g.setGain(myKnobA.value());  // volume knob
  modFreqRatio.setValue(myKnobB.value());
  carrierFreq.setValue(myKnobE.value());
 
  // 2 knobs for the bottom synth
  g2.setGain(myKnobC.value());  //Volume knob
  wp2.setFrequency(myKnobD.value());
}
 
// The control of the matrix
 
void controlEvent(ControlEvent theEvent)
  { 
  if (theEvent.controller().name()=="topMatrix")
      {
      carrierFreq.setValue(theEvent.controller().value());
      }
   
  if (theEvent.controller().name()=="baseMatrix")
      {
      wp2.setFrequency((theEvent.controller().value()+100*myKnobD.value()));
      }
  }
 
// The control of the knob
// which might be a better way to setup the synth
// so leaving it here for future dev
 
void knob(int theValue) {
}

