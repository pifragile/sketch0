import java.util.Arrays;   
PImage img0, img1;
int cs = 1080;

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
int numLoops = 0;

// Zersetzungsstärke, Alle Werte möglich, 1 - 10 ist spannend, 0 = randomisiert
int globalIters = 2;

////////
///////
String folderPath = "";
PGraphics g;
float speed;
int strength;
float bloat;
int density;

void setup() {
    size(1080, 1080);
 
    pixelDensity(1);
    folderPath = "./images/" + Integer.toString((int) random(999999999)) + "/";
    new File(folderPath).mkdirs();

    g = createGraphics(cs, cs);
    g.beginDraw();
    g.background(10,10,10,255);


    String s1=dataPath("");

    String img0Folder = "img/aiSelina/";
    File path0 = new File(s1+"/" + img0Folder);
    String[] images0 = path0.list();
    img0 = loadImage(img0Folder + images0[(int)random(images0.length)]);

    String img1Folder = "img/aiSelina/";
    File path1 = new File(s1+"/" + img1Folder);
    String[] images1 = path1.list();
    img1 = loadImage(img1Folder + images1[(int)random(images1.length)]);


    img0.resize(cs, cs);
    int resize = (int) 1;//random(3) + 1;
    img1.resize((int) (cs * resize), (int) (cs * resize));


    PGraphics res0 = processImage(img0);
       
    //g.image(img0, 0, 0, cs, cs);

    // g.tint(zTint, zTint);
    // g.image(res0, 0, 0, cs, cs);
    g.endDraw();

    frameRate(25);
    background(0,0,0,255);
    speed = random(0.05) + 0.0025;
    strength = 200;//(int) random(200) + 50;
    bloat = 1;
    density = 100;
}

PImage betweenImage;
void draw() {
    g.beginDraw();
    g.blendMode(BLEND);

    if(frameCount > 1 && random(1) <  speed * 2){
        zTint = (int) random(100);
        
        g.tint(255, zTint);
        g.image(betweenImage, 0, 0, cs, cs);
    
        // g.tint((int) random(50), (int) random(20));
        // g.image(res0, 0, 0, cs, cs);

    }

    int imgWidth = cs;
    int imgHeight = cs;
    
    if(frameCount == 1 || random(1) < speed * 0.5) {
        density = (int) 10;//random(50) + 30;
        bloat = random(3) + 0.5;
        for(int i = 0; i < density; i++) {
            g.blendMode(random(1) < 0.05 ? DODGE : HARD_LIGHT);
            //g.drawingContext.globalAlpha = 0.9;
            
            PImage im = random(1.0) < 0.5 ? img0 : img1;
            
            int x = floor(random(im.width * 0.2));`
            int y = floor(random(im.height * 0.2));
            int sw = ceil((im.width - x - 1) * (random(0.2) + 0.8) + 1);
            int sh = ceil((im.height - y - 1) * (random(0.2) + 0.8) + 1);
            PImage subImg = im.get(x, y, sw, sh);

            PGraphics res = processImage(subImg);

            if((frameCount % vidLength) == 1 || random(1) < 0.2) {betweenImage = g.get();}

            g.tint(255, 255);
            g.image(res, random(g.width - sw * bloat), random(g.height - sh * bloat), res.width * bloat, res.height * bloat);

            //g.blend(res, 0, 0, res.width, res.height, floor(random(g.width)), floor(random(g.height)), res.width, res.height, HARD_LIGHT);
                }
    }
    g.endDraw();
    //tint(255, 100);

    //PImage imgBack = get();
    //clear();
    tint(255, frameCount == 1 ? 255 : 40);
    image(g, 0, 0, g.width, g.height);
    // tint(255, 255);
    // image(imgBack, 0, 0, cs, cs);

    // //g.save(folderPath + Integer.toString((int) random(999999999)) + "_" + zTint+ "_" + numLoops + "_" + globalIters + ".png");
    // //noLoop();
    rec();
    
}

PGraphics processImage(PImage img) {
    int w = img.width;
    int h = img.height;
    PGraphics pg = createGraphics(w, h);
    pg.beginDraw();
    //pg.pixelDensity(1);
    pg.image(img, 0.0, 0.0, (float) w, (float) h);
    pg.loadPixels();
    int numIters = globalIters == 0 ? floor(random(50.0)): globalIters;//floor(random(10.0));
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
    //pg.filter(POSTERIZE, 2);
    pg.endDraw();
    return pg;
}
