class Stop {
    PVector pos;
    int lines = 0;
    String name = "empty";
    color c = color(120);

    void paint() {
        c = color(10);
        float x = map(pos.x,config.mapMinX ,config.mapMaxX, 0 + config.borderWidth, config.screen_w - config.borderWidth);
        float y = map(pos.y,config.mapMinY ,config.mapMaxY, config.screen_h - config.borderWidth, 0 + config.borderWidth);
        if(lines > 1) c = color(40);
        if(lines > 2) c = color(80);
        if(lines > 3) c = color(160);
        if(hoverEffect()) {
            c = color(#FFA021);
            if(!config.nameList.hasValue(name)) config.nameList.append(name);
        }
        stroke(c);
        noFill();
        circle(
            x,
            y,
            2 + lines
        );
    }

    boolean hoverEffect() {
        int distance = 8;
        float x = map(pos.x,config.mapMinX ,config.mapMaxX, 0 + config.borderWidth, config.screen_w - config.borderWidth);
        float y = map(pos.y,config.mapMinY ,config.mapMaxY, config.screen_h - config.borderWidth, 0 + config.borderWidth);
        if(dist(mouseX - config.screen_offset_x, mouseY - config.screen_offset_y, x, y) <= distance) return true;
        return false;
    }
}