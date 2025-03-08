class Brick {
  // Brick properties: position, size, type, and state
  float x, y, width, height;
  int type; // Type determines color and hit durability
  boolean destroyed; // Whether the brick is broken
  int hitCount;  // Counter to track how many times the brick is hit
  color col;     // Custom color for bricks (used for moving bricks)

  // Constructor to initialize a brick with position, size, and type
  Brick(float x, float y, float w, float h, int type) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.type = type;
    this.destroyed = false; // Initially, the brick is not destroyed
    this.hitCount = 0;  // Initialize hit count to 0
    this.col = getColor(type); // Set the initial color based on type
  }

  // Draw the brick if it is not destroyed
  void draw() {
    if (!destroyed) {
      fill(col); // Use the custom color
      rect(x, y, width, height); // Draw the brick as a rectangle
    }
  }

  // Get the color of the brick based on its type and hit count
  color getColor(int type) {
    switch (type) {
      case 1:  // Red brick (takes 3 hits to destroy)
        if (hitCount == 0) return color(200, 50, 50);  // Original red
        if (hitCount == 1) return color(255, 100, 100);  // Lighter red after 1 hit
        if (hitCount == 2) return color(255, 150, 150);  // Even lighter red after 2 hits
        return color(255, 200, 200);  // Disappears after 3 hits
      case 2:  // Yellow brick (disappears after 1 hit)
        return color(240, 200, 80);
      case 3:  // Green brick (takes 2 hits to destroy)
        if (hitCount == 0) return color(80, 160, 80);  // Original green
        if (hitCount == 1) return color(120, 200, 120);  // Lighter green after 1 hit
        return color(160, 240, 160);  // Disappears after 2 hits
      default:
        return color(255);  // Default white (for any undefined type)
    }
  }

  // Handle brick being hit by the ball
  void hit() {
    hitCount++;  // Increment the hit count when the brick is hit

    // Award points based on brick type and hits needed to destroy it
    if (type == 2 && hitCount == 1) {  // Yellow brick (1 hit required)
      score.addPoints(1);
      destroyed = true;  // Yellow brick disappears after 1 hit
    } else if (type == 3 && hitCount == 2) {  // Green brick (2 hits required)
      score.addPoints(2);
      destroyed = true;
    } else if (type == 1 && hitCount == 3) {  // Red brick (3 hits required)
      score.addPoints(3);
      destroyed = true;
    }

    // Update the brick's color after being hit
    col = getColor(type);
  }
}