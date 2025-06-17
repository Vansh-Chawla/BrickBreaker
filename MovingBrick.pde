class MovingBrick extends Brick {
  int speed; 
  int direction; 

  // these control the range of motion of the brick
  float leftBoundary; 
  float rightBoundary; 

  MovingBrick(float xPos, float yPos, float w, float h, BrickType type, int speed, float leftBoundary, float rightBoundary) {
    super(xPos, yPos, w, h, type);
    this.speed = speed;
    this.direction = 1; // Default direction
    this.leftBoundary = leftBoundary; 
    this.rightBoundary = rightBoundary; 
    this.col = type.getColor(0);
  }


  void update() {
    // Move the brick horizontally
    xPos += speed * direction;

    // Reverse direction if the brick hits the boundaries
    if (xPos + width > rightBoundary || xPos < leftBoundary) {
      direction *= -1; 
    }
  }

  @Override
  void draw() {
    if (!destroyed) {
      col = type.getColor(hitCount); // make sure brick is correct color before drawing
      fill(col);
      rect(xPos, yPos, width, height);
      update(); // Update the brick's position
    }
  }
}
