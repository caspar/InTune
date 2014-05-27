// The display of the 2 waves
 
 
void wave()
{
 
  loadPixels();
  Arrays.fill(pixels, color(0));
  //scan across the pixels
  for(int i = 0; i < width; i++)
  {
    //for each pixel work out where in the current audio buffer we are
    int buffIndex = i * ac.getBufferSize() / width;
    //then work out the pixel height of the audio data at that point
    //int vOffset = (int)((1 + g.getValue(0, buffIndex)) * height/1.15);
    int vOffset1 = (int)((18 + wp.getValue(0, buffIndex)) * height/22);
    int vOffset2 = (int)((20 + wp2.getValue(0, buffIndex)) * height/22);
 
    //draw into Processing's convenient 1-D array of pixels
 
    pixels[vOffset1 * height + i] = fore;
    pixels[vOffset2 * height + i] = color(255,0,0);
  }
  updatePixels();
}

