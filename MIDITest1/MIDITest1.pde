import controlP5.*;
import java.util.Arrays;
ControlP5 controlP5;

import themidibus.*;
import beads.*;
Gain g;

AudioContext ac;
WavePlayer wp;

MidiBus myBus; // The MidiBus

Knob volume;
Knob level;

void setup() {
  size(400,400);
  background(0);
  smooth();

  //Code for the Knobs
  controlP5 = new ControlP5(this);
  volume = controlP5.addKnob("volume",0,0.8,0,40,30,120);
  level = controlP5.addKnob("level",0,2,0,230,70,80);

  // Code for the synth
  ac = new AudioContext();
  wp = new WavePlayer(ac, 0, Buffer.SINE);
  g = new Gain(ac, 1, 0);
  g.addInput(wp);
  ac.out.addInput(g);
  ac.start();

  // Code for the midi controler
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, ""); // Create a new MidiBus with no input device - you will have to change the input here
}

color fore = color(92, 169, 250);
color back = color(0,0,0);

void draw()
{
  loadPixels();
  //set the background
  Arrays.fill(pixels, back);
  //scan across the pixels
  for(int i = 0; i < width; i++) {
    //for each pixel work out where in the current audio buffer we are
    int buffIndex = i * ac.getBufferSize() / width;
    //then work out the pixel height of the audio data at that point
    int vOffset = (int)((1 + ac.out.getValue(0, buffIndex)) * height / 2);
    //draw into Processing's convenient 1-D array of pixels
    pixels[vOffset * height + i] = fore;
  }
  updatePixels();
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn from your midi device
  wp.setFrequency(6.875 *(pow(2.0,((3.0+(pitch*level.value()))/12.0))));
  // The calculation of the midi note to frequency is 6.875 * 2 exp ((3+note)/12)
  // I added one knob value in order to go trough all the note in the scale,
  // if your midi controller has a octave up and down that knob is not needed
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff - or releasing the note from your midi device
   wp.setFrequency(0);
}

void volume(float theValue) {
  g.setGain(theValue);   // the volume knob on the left
}

