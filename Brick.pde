class Brick {
  float xPos, yPos, width, height;
  BrickType type; // from enum BrickType
  boolean destroyed;
  int hitCount;  
  color col; 

  Brick(float xPos, float yPos, float w, float h, BrickType type) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.width = w;
    this.height = h;
    this.type = type;
    this.destroyed = false; // Initially, the brick is not destroyed
    this.hitCount = 0;
    this.col = type.getColor(0); // Get the initial color for the type of brick
  }

  // Draw the brick if it is not destroyed
  void draw() {
    if (!destroyed) {
      col = type.getColor(hitCount); // update color based on hitcount
      fill(col); 
      rect(xPos, yPos, width, height); 
    }
  }


  void hit() {
    hitCount++; 

    if (type == BrickType.YELLOW && hitCount == 1) {  // Yellow brick (1 hit to destroy)
      score.addPoints(1);
      destroyed = true;
    } else if (type == BrickType.GREEN && hitCount == 2) {  // Green brick (2 hits to destroy)
      score.addPoints(2);
      destroyed = true;
    } else if (type == BrickType.RED && hitCount == 3) {  // Red brick (3 hits to destroy)
      score.addPoints(3);
      destroyed = true;
    }
  }


  // these methods are for collision of the ball with the corners of a brick
  float[] getBottomLeftCorner() {
    float[] coords = {xPos, yPos + height};
    return coords;
  }
  float[] getBottomRightCorner() {
    float[] coords = {xPos + width, yPos + height};
    return coords;
  }
  float[] getTopLeftCorner() {
    float[] coords = {xPos, yPos};
    return coords;
  }
  float[] getTopRightCorner() {
    float[] coords = {xPos + width, yPos};
    return coords;
  }
}
