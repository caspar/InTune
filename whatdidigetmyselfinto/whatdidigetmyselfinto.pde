import java.themidibus.*;

float controllers[] = new float[100]; //i have no idea how many there can be

MidiBus bus;

void setup(){
    size(500, 500);
    background(0);
    bus = new MidiBus(); //i think this would be a lot easier if i actually had the friggin control thingy
}

void draw(){
    background(0);
    //do shit over here lol
    //ex rect(controllers[1]*width, controllers[2]*height, controllers[3]*40, controllers[4]*40);
    //i guess i assumed i mapped 1 and 2 to between 0 and 1
}

void controllerChange(int channel, int number, int value){
    controllers[number] = value; // i should probably map value to something but idk what it goes up to
}
