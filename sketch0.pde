import java.util.Arrays;   
PImage img0, img1;


void setup() {
    size(1000, 1000);
    String s1=dataPath("");
    img0 = loadImage(s1+"/"+"img/raum/3a.jpg");
    img1 = loadImage(s1+"/"+"img/ptth/3a.jpg");
    
    pixelDensity(1);
}

void draw() {
    //background(255);
    if (img0 != null && img0.width > 0 && img1 != null && img1.width > 0) {
        int imgWidth = min(img0.width, img1.width);
        int imgHeight = min(img0.height, img1.height);
            
        PGraphics g = createGraphics(imgWidth, imgHeight);
        g.beginDraw();
        g.background(10,10,10,255);
        g.blendMode(DODGE);
        //g.drawingContext.globalAlpha = 0.9;
        g.tint(200, 200);
        
        for (int i = 0; i < 50; i++) {
            PImage im = random(1.0) < 0.5 ? img0 : img1;
            
            int x = floor(random(im.width));
            int y = floor(random(im.height));
            int sw = ceil((im.width - x - 1) * (random(0.6) + 0.2) + 1);
            int sh = ceil((im.height - y - 1) * (random(0.6) + 0.2) + 1);
            PImage subImg = im.get(x, y, sw, sh);
     
            PGraphics res = processImage(subImg);
            g.image(res, random(g.width), random(g.height), res.width, res.height);
            //g.blend(res, 0, 0, res.width, res.height, floor(random(g.width)), floor(random(g.height)), res.width, res.height, HARD_LIGHT);
        }
        g.endDraw();
        image(g, 0, 0, g.width, g.height);
        noLoop();
    }
}

PGraphics processImage(PImage img) {
    int w = img.width;
    int h = img.height;
    PGraphics pg = createGraphics(w, h);
    pg.beginDraw();
    //pg.pixelDensity(1);
   
    pg.image(img, 0.0, 0.0, (float) w, (float) h);
    pg.loadPixels();
    int numIters = floor(random(10.0));
    int pl = pg.pixels.length;
    for (int _x = 0; _x < numIters; _x++) {
        int sectionLength = max(0, floor(random(pl * 0.5) - 4 - 1) + 1);

        int copyPos = floor(random(pl - sectionLength));
        int insertPos = floor(random(pl - sectionLength)); 
                           
        if (random(1.0) < 0.5) {
            int cpo = copyPos % 4;
            int ipo = insertPos % 4;
            insertPos += cpo - ipo;

            if (insertPos + sectionLength >= pl) insertPos -= 4;
        }

        int[] section = Arrays.copyOfRange(pg.pixels, copyPos, copyPos + sectionLength);
        //int al = random(255)
        //section = section.map((x, i) => x == 255 ? al: x)
        int len = section.length;
        for(int i = 0; i < len; i++) {
          pg.pixels[insertPos + i] = section[i];
        }
    }
    pg.updatePixels();
    pg.filter(POSTERIZE, 2);
    pg.endDraw();
    return pg;
}
