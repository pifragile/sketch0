final String sketchname = getClass().getName();

import com.hamoid.*;
VideoExport videoExport;
int vidLength = 40;

int FRAME_RATE = 25;
int frameLength = vidLength * FRAME_RATE;

void rec() {
  if (frameCount % frameLength  == 1) {
    if(frameCount > 1) {
          videoExport.endMovie();
          setup();
    }
    videoExport = new VideoExport(this, "../"+sketchname+ Integer.toString((int) random(999999999)) +".mp4");
    videoExport.setFrameRate(FRAME_RATE);  
    videoExport.startMovie();
  }
  videoExport.saveFrame();
}