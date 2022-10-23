import java.util.Arrays;   
PImage img0, img1;

////////
//// Mit diesen Werten und Bildpfaden könnt ihr runspielen, also einfach die Zahlen ändern.
//// Die Bilder müsst ihr im data ordner ablegen und dann unten den Pfad angeben
//// Es gibt immer 2.Bilder. Ich habe jetzt als das erste Bild immer ein Raumbild genommen
//// und als zweites ein ptth. Da könnt ihr natürlich alles ausprobieren!

//// Dann könnt ihr oben auf play drücken, und los gehts :)
//// Drückt auch mehrmals, es gibt immer andere outputs, wegen random!
/////

// Grundzersetzung, Werte zwischen 0 und 255
int zTint = 150;

// Zersetzungsdurchläufe, Werte zwischen 0 und 10
int numLoops = 3;

// Zersetzungsstärke, Alle Werte möglich, 1 - 10 ist spannend, 0 = randomisiert
int globalIters = 2;

// Bildpfade, Relativer pfad ab <SKETCH_ORDNER>/data
String img0Path = "img/raum/3a.jpg";
String img1Path = "img/ptth/3a.jpg";
////////
///////


void setup() {
    size(1000, 1000);
    String s1=dataPath("");
    img0 = loadImage(s1+"/"+img0Path);
    img1 = loadImage(s1+"/"+img1Path);
    
    pixelDensity(1);
}

void draw() {
    //background(255);
    if (img0 != null && img0.width > 0 && img1 != null && img1.width > 0) {
        int imgWidth = img0.width;
        int imgHeight = img0.height;
            
        PGraphics g = createGraphics(imgWidth, imgHeight);
        g.beginDraw();
        g.background(10,10,10,255);
        g.blendMode(DODGE);
        //g.drawingContext.globalAlpha = 0.9;
        
        
        PGraphics res0 = processImage(img0);
       
        g.image(img0, 0, 0, imgWidth, imgHeight);

        g.tint(zTint, zTint);
        g.image(res0, 0, 0, imgWidth, imgHeight);
        g.tint(200, 200);
        for (int i = 0; i < numLoops; i++) {
            PImage im = random(1.0) < 0.5 ? img0 : img1;
            
            int x = floor(random(im.width * 0.5));
            int y = floor(random(im.height * 0.5));
            int sw = ceil((im.width - x - 1) * (random(0.3) + 0.7) + 1);
            int sh = ceil((im.height - y - 1) * (random(0.3) + 0.7) + 1);
            PImage subImg = im.get(x, y, sw, sh);
     
            PGraphics res = processImage(subImg);
            g.image(res, random(g.width - sw), random(g.height - sh), res.width, res.height);
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
    int numIters = globalIters == 0 ? floor(random(10.0)): globalIters;//floor(random(10.0));
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
