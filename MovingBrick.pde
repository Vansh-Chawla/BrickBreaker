class MovingBrick extends Brick {
  int speed; 
  int direction; 
  float leftBoundary; 
  float rightBoundary;

  // Constructor
  MovingBrick(float x, float y, float w, float h, int type, int speed, float leftBoundary, float rightBoundary) {
    super(x, y, w, h, type); // Call the parent constructor with the correct type
    this.speed = speed;
    this.direction = 1; // Default direction (can be overridden)
    this.leftBoundary = leftBoundary; // Set the left boundary
    this.rightBoundary = rightBoundary; // Set the right boundary
    this.col = getColor(type); // Set the color based on the type
  }

  // Update method to handle movement
  void update() {
    // Move the brick horizontally
    x += speed * direction;

    // Reverse direction if the brick hits the boundaries
    if (x + width > rightBoundary || x < leftBoundary) {
      direction *= -1; // Reverse direction
    }
  }

  // Override the draw method to include movement
  void draw() {
    if (!destroyed) {
      fill(col); // Use the custom color
      rect(x, y, width, height);
      update(); // Update the brick's position
    }
  }
}