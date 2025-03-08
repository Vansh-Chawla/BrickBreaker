class Ball {
  // Defining ball properties
  float xpos, ypos, xspeed, yspeed;
  int rad, xdirection, ydirection;
  boolean ballMoving;
  int bricksDestroyed = 0; // Track destroyed bricks for speed increase

  // Constructor to initialize ball properties
  Ball(float x, float y) {
    xpos = x;
    ypos = y;
    xspeed = 3.4;
    yspeed = 3.6;
    rad = 10;
    xdirection = 1; //Ball moves right initially
    ydirection = 1; //Ball moves down initially
    ballMoving = false; //Ball is not moving initially
  }

  // Update ball position
  void update() {
    if (ballMoving) {
      xpos += xspeed * xdirection;
      ypos += yspeed * ydirection;
      collision(); // Check for collision
    }
  }

  // Check for collision with walls
  void checkCollision(int width, int height, int borderThickness) {
    // Collision with right and left walls
    if (xpos > width - rad - borderThickness || xpos < borderThickness + rad) {
      xdirection *= -1; // Reverse direction horizontally
    }
    // Collision with top and bottom walls
    if (ypos < borderThickness + rad) {
      ydirection *= -1; // Reverse direction vertically
    }
  }

  // Check for collision with paddle and bricks
  void collision() {
    // Paddle Collision with Bounce Angle Adjustment
    if (ypos + rad > rectY && ypos - rad < rectY + rectHeight &&
        xpos + rad > rectX && xpos - rad < rectX + rectWidth) {
      
      float hitPos = (xpos - rectX) / rectWidth - 0.5; // Normalized (-0.5 to 0.5)
      xspeed = 3.4 + abs(hitPos) * 2; // Increase speed based on hit position
      ydirection *= -1; // Reverse direction vertically
      xdirection = hitPos > 0 ? 1 : -1; // Change direction based on hit position
    }

    // Brick Collision Detection
    for (int i = bricks.size() - 1; i >= 0; i--) {
      Brick b = bricks.get(i);
      if (!b.destroyed && xpos + rad > b.x && xpos - rad < b.x + b.width &&
    ypos + rad > b.y && ypos - rad < b.y + b.height) {
  
    ydirection *= -1; // Bounce off the brick
    b.hit();  // Call hit() method

    if (b.destroyed) {
        bricksDestroyed++; // Track how many bricks are destroyed
        
        if (bricksDestroyed % 5 == 0) { // Every 5 bricks, increase speed
            xspeed *= 1.1;
            yspeed *= 1.1;
        }

        // if specific bricks are hit they shrink or expand the paddle
        if (b.type == 3) { // red bricks shrink paddle
            rectWidth = max(60, rectWidth - 8);
        } else if (b.type == 1) { // green bricks expand paddle
            rectWidth = max(30, rectWidth - 12);
        }
    }
}

    }

    // Lose Life if Ball Falls Below Screen
    if (ypos > height) {
      lives.loseLife(); // Decrease life count
      if (!lives.isGameOver()) {
        resetBall(); // Reset ball position
      }
    }
  }

  // Reset ball position after losing a life
  void resetBall() {
    xpos = rectX + rectWidth / 2; // Center ball on the paddle
    ypos = rectY - 10; // Place ball slightly above the paddle
    ballMoving = false; // Stop the ball
  }

  // Draw the ball
  void draw() {
    fill(128, 0, 128);
    ellipse(xpos, ypos, rad, rad);
  }
}
