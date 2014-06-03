import themidibus.*;
import controlP5.*;
import java.util.*;

Knob a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;

Knob[] knobs = {
  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p
};

ControlP5 cp5;
MidiBus bus; 



void setup() {
  size(1280, 758);
  background(0);
  smooth();
  noStroke();

  cp5 = new ControlP5(this);
  for (int i = 0; i < knobs.length; i++) {
    knobs[i] = cp5.addKnob(""+i)
      .setRange(0, 127)
        .setPosition(80*i+10, height-90)
          .setRadius(30)
            .setDragDirection(Knob.VERTICAL)
              .setDecimalPrecision(0)
                .shuffle()
                  .setShowAngleRange(false)
                    ;
    knobs[i].setLabel(""+"knob "+knobs[i].getName());
  }
}

void draw() {
}

void controllerChange(int channel, int number, int value) {
  println("CC: " + number + " @ " + value);
  knobs[number-9].setValue(value);
}

