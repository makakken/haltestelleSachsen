
import processing.svg.*;
boolean record = false;

JSONObject json;

Config config = new Config();

String timestamp = str(year()) + '_'
  + str(month()) + '_'
  + str(day()) + '_'
  + str(hour())
  + str(minute());

void setup() {
  background(#324854);
  json = loadJSONObject("vvo_haltestellen.json");
  JSONArray stops = json.getJSONArray("stops");
  getBoundingBox(stops);
  fullScreen();
}

void draw() {
  if (record) {
    beginRecord(SVG, "gfx/map-" + timestamp + ".svg");
  }
  background(#324854);
  noFill();
  stroke(240);
  drawStops();
  drawNames();
  if (record) {
    endRecord();
    println("frame saved...");
    record = false;
  }
}

void mousePressed() {
  record = true;
}

void paintPulseDot(float x, float y, int times) {
    circle(x,y,times);
}

void getBoundingBox(JSONArray data) {
    float xmin = 0;
    float xmax = 0;
    float ymin = 0;
    float ymax = 0;

    for (int i = 0; i < data.size(); i++) {
        JSONObject stop = data.getJSONObject(i);
        float x =  stop.getFloat("x", 0);
        float y =  stop.getFloat("y", 0);
        int l =  stop.getJSONArray("Lines").size();
        String name = stop.getString("name","none");
        String place = stop.getString("place","none");

        if(x != 0 && y != 0) {
            if(i == 0) { xmin = x; xmax = x; ymin = y; ymax = y; }
            if(x < xmin) xmin = x;
            if(x > xmax) xmax = x;
            if(y < ymin) ymin= y;
            if(y > ymax) ymax = y;
            PVector pos = new PVector(x,y);
            Stop s = new Stop();
            s.pos = pos;
            s.lines = l;
            s.name = place + ", " + name;
            config.stops.add(s);
        }
    }

    config.mapMinX = xmin;
    config.mapMaxX = xmax;
    config.mapMinY = ymin;
    config.mapMaxY = ymax;

    println("Distanz x:" , xmax-xmin);
    println("Distanz y:" , ymax-ymin);
    println("Ratio", (ymax-ymin) / (xmax-xmin));
    println("Recommended Screen size:", width, width * ((ymax-ymin) / (xmax-xmin)));
    config.screen_w  = width;
    config.screen_h = floor(width * ((ymax-ymin) / (xmax-xmin)));
    config.screen_offset_x = ((width - config.screen_w) / 2);
    config.screen_offset_y = ((height - config.screen_h) / 2);
}

void drawStops() {
    config.nameList.clear();
    translate(
        config.screen_offset_x,
        config.screen_offset_y
    );
    for (int i = 0; i < config.stops.size(); i++) {
        Stop s = config.stops.get(i);
        s.paint();
    }
}

void drawNames() {
    int size = 20;
    fill(#FFA021, 240);
    textSize(size);
    for(int i = 0; i < config.nameList.size(); i++) {
        text(config.nameList.get(i), mouseX + 10, mouseY - config.screen_offset_y + (size + 2) * i);
    }
    noFill();
}