class Ball {
  float currentXPos, currentYPos, speed;
  float rad;

  // these are private so that the directions can only be changed via setters that will call the method to make the direction a unit vector
  private float xdirection, ydirection;

  boolean ballMoving;

  Ball(float x, float y, int speed) {
    currentXPos = x;
    currentYPos = y;

    this.speed = speed;

    rad = 5;



    // ball moves up and right initially
    setXDirection(0.5);
    setYDirection(-1);

    ballMoving = false; //Ball is not moving initially
  }

  void makeDirectionVectorUnitVector() {
    // makes the direction vector a unit vector so that changes to the direction do not change the speed (magnitude of vector always 1)
    float magnitude = (float)Math.hypot(xdirection, ydirection);
    xdirection /= magnitude;
    ydirection /= magnitude;
  }

  void updatePosition(int width, int height, int borderThickness) {
    // this moves the ball along, and checks for collisions with the ball
    if (ballMoving) {

      int stepCount = 8; // this controls how the movement of the ball is split up (to try to avoid phasing through corners at high speed)
      for (int i = 0; i < stepCount; i++) {
        currentXPos += (xdirection * speed)/stepCount;
        currentYPos += (ydirection * speed)/stepCount;

        // it only needs to check one collision per movement of the ball - there's no point always checking every collision 
        if (!checkPaddleCollision()){
          if (!checkBrickCollision()) {
            if (!checkCollisionWithWall(width, height, borderThickness)) {
              checkBallOutOfBounds();
            }
          }
        }
      }
    }
  }
  
  //this is called by checkBrickCollision
  boolean checkBrickCornerCollision(Brick b) {

      // if potententially headed for a bottom corner
      if (ydirection < 0) { 
        // if colliding with bottom right corner
        if (dist(currentXPos, currentYPos, b.getBottomRightCorner()[0], b.getBottomRightCorner()[1]) <= rad) {
          // reverse direction for corner hit
          System.out.println("bottom right collision");
          if (xdirection > 0) {
            ydirection *= -1;
          } else {
            xdirection *= -1;
            ydirection *= -1;
          }

          // move ball out of corner
          currentXPos = b.getBottomRightCorner()[0] + 1;
          currentYPos = b.getBottomRightCorner()[1] + 1;
          return true;
        } 
        // if colliding with bottom left corner
        if (dist(currentXPos, currentYPos, b.getBottomLeftCorner()[0], b.getBottomLeftCorner()[1]) <= rad) {
          System.out.println("bottom left collision");
          if (xdirection < 0) {
            ydirection *= -1;
          } else {
            xdirection *= -1;
            ydirection *= -1;
          }

          currentXPos = b.getBottomLeftCorner()[0] + 1;
          currentYPos = b.getBottomLeftCorner()[1] + 1;
          return true;
        }

        // if potentially headed for a top corner
      } else if (ydirection > 0) {
        // if colliding with top right corner
        if (dist(currentXPos, currentYPos, b.getTopRightCorner()[0], b.getTopRightCorner()[1]) <= rad) {
          System.out.println("top right collision");
          if (xdirection > 0) {
            ydirection *= -1;
          } else {
            xdirection *= -1;
            ydirection *= -1;
          }

          currentXPos = b.getTopRightCorner()[0] +  1;
          currentYPos = b.getTopRightCorner()[1] +  1;
          return true;
        }
        // if colliding with top left corner
        if (dist(currentXPos, currentYPos, b.getTopLeftCorner()[0], b.getTopLeftCorner()[1]) <= rad) {
          System.out.println("top left collision");
          if (xdirection < 0) {
            ydirection *= -1;
          } else {
            xdirection *= -1;
            ydirection *= -1;
          }

          currentXPos = b.getTopLeftCorner()[0] + 1;
          currentYPos = b.getTopLeftCorner()[1] + 1;
          return true;
        }
      }

      return false;
  }

  // This is called by update
  boolean checkPaddleCollision() {

    if (currentYPos + rad > paddleY && currentYPos - rad < paddleY + paddleHeight &&
        currentXPos + rad > paddleX && currentXPos - rad < paddleX + paddleWidth) {
          
          // move ball out of collision zone
          currentYPos -= rad/2;

          float middleOfPaddleX = paddleX + (paddleWidth / 2); // paddlex is the top left hand corner of the paddle

          if (currentXPos != middleOfPaddleX) { // if ball hits direct middle of paddle, don't change xdirection
            // dividing by half the paddle width means that this can only be between -1 and 1 inclusive.
            setXDirection((currentXPos - middleOfPaddleX) / (paddleWidth / 2));
          }

          ydirection *= -1; // y direction always needs to be flipped

          if (abs(xdirection) < 0.25) { // if the angle of the ball's trajectory is too steep (i.e. close to vertical), make it shallower
            System.out.println("made steeper");
            System.out.println(xdirection);
            setXDirection((xdirection > 0) ? 0.25 : -0.25); 
            System.out.println(xdirection);
          }

          return true; 
    }

    return false;
  }


    // MAYBE ADD SOME SORT OF CHECK HERE TO SEE IF THE BALL IS BELOW THE LOWEST BRICK ALREADY AND GOING DOWN?

    // MAYBE ADD SOME SORT OF CHECK HERE TO ONLY CHECK BRICKS CLOSE TO THE BALL?

  boolean checkBrickCollision() {
    for (int i = bricks.size() - 1; i >= 0; i--) {
      Brick b = bricks.get(i);


      // first check corner collision
      if (!b.destroyed) {
        boolean cornerCollided = checkBrickCornerCollision(b); 

        if (cornerCollided) {
          b.hit();
          if (b.destroyed) {
            if (b.type == BrickType.RED) { // red bricks shrink paddle
              paddleWidth = max(60, paddleWidth - 9);
            } else if (b.type == BrickType.GREEN) { // green bricks expand paddle
              paddleWidth = min(75, paddleWidth + 12);
            }
          }
          return true; // There was a collision
        }
      }


      // check general collisions with bricks (i.e. sides)
      if (!b.destroyed && (currentXPos + rad > b.xPos) && (currentXPos - rad < (b.xPos + b.width)) &&
      (currentYPos + rad > b.yPos) && (currentYPos - rad < (b.yPos + b.height))) {
      // if b not destroyed, and edge of ball within brickx, and edge of ball within bricky, then collision


        if (currentXPos > b.getTopRightCorner()[0] || currentXPos < b.xPos) { // if ball left or right of brick
          xdirection *= -1; // then colliding with vertical side of brick, so flip x direction
          b.hit();  // Call hit() method
        } else {
          ydirection *= -1; // can only be colliding with bottom or top of brick otherwise
          b.hit();  // Call hit() method
        }
  

        if (b.destroyed) {
          if (b.type == BrickType.RED) { 
            paddleWidth = max(60, paddleWidth - 9);
          } else if (b.type == BrickType.GREEN) { 
            paddleWidth = min(75, paddleWidth + 12);
          }
        }

        return true; // there was a collision
      }
    }
      return false; // there was not a collision

  }


    // this is called from update
  boolean checkCollisionWithWall(int width, int height, int borderThickness) { 

  // Collision with right and left walls
  if (currentXPos > width - rad - borderThickness || currentXPos < borderThickness + rad) {
    xdirection *= -1; // Reverse direction horizontally
    return true;
  }
  // Collision with top wall
  if (currentYPos < borderThickness + rad) {
    ydirection *= -1; // Reverse direction vertically
    return true;
  }

    return false; // if no collision with walls
  }

  // this is called from update
  void checkBallOutOfBounds() {
    if (currentYPos > height) {
      lives.loseLife(); 
      if (!lives.haveRunOut()) {
        resetBall(); // Reset ball position
      }
    }
  }

  // Reset ball position after losing a life
  void resetBall() {
    paddleX = (600 - paddleWidth) / 2;
    currentXPos = paddleX + paddleWidth / 2; // Center ball on the paddle
    currentYPos = paddleY - 10; // Place ball slightly above the paddle
    ballMoving = false; // Stop the ball

    // ball moves up and right initially
    setXDirection(0.5);
    setYDirection(-1);
  }

  // Draw the ball
  void draw() {
    ellipseMode(RADIUS);
    fill(128, 0, 128);
    ellipse(currentXPos, currentYPos, rad, rad);
  }


  // these methods are for changing direction of ball after collision with creature
  void multiplyXDirection(float multiplier) {
    this.xdirection *= multiplier;
    makeDirectionVectorUnitVector();
  }

  void multiplyYDirection(float multiplier) {
    this.ydirection *= multiplier;
    makeDirectionVectorUnitVector();
  }

  // these methods ensure that when the x or y direction is changed, the vector of the movement of the ball remains a unit vector
  void setXDirection(float dir) {
    this.xdirection = dir;
    makeDirectionVectorUnitVector();
  }

  void setYDirection(float dir) {
    this.ydirection = dir;
    makeDirectionVectorUnitVector();
  }
}
