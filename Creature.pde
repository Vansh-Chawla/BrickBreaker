abstract class Creature {
  float currentXPos, currentYPos, speed;
  float rad, xdirection, ydirection;

  Creature(float startXPos, float startYPos, float speed, float rad, float startxdirection, float startydirection) {
    this.currentXPos = startXPos;
    this.currentYPos = startYPos;
    this.speed = speed;
    this.rad = rad;
    this.xdirection = startxdirection;
    this.ydirection = startydirection;

    makeDirectionVectorUnitVector(); // make sure that direction vector is unit vector

  }


  abstract void updatePosition(); // different creatures may move in different ways

  abstract void draw(); // different creatures may be different shapes etc.


  void checkCollisionWithWall(int width, int height, int borderThickness) {

    // collision with right wall
    if (currentXPos > width - (rad + 1) - borderThickness) {
      xdirection *= -1; 
      ydirection += random(-2, 2); 
      currentXPos -= 1 ; // move the creature out of the way
      makeDirectionVectorUnitVector();
    }
    // collision with left wall
     else if (currentXPos < borderThickness + (rad + 1)) {
      xdirection *= -1; 
      ydirection += random(-2, 2); 
      currentXPos += 1 ; // move the creature out of the way
      makeDirectionVectorUnitVector();
     }
    // collisoin with imaginary bottom wall
    else if (currentYPos > height - (rad+1)) {
      ydirection *= -1; 
      xdirection += random(-2, 2);
      currentYPos -= 1 ;
      makeDirectionVectorUnitVector();
    }
    // collision with top wall
    else if (currentYPos < borderThickness + (rad+1)) {
      ydirection *= -1; 
      xdirection += random(-2, 2);
      currentYPos += 1 ;
      makeDirectionVectorUnitVector();        
    }
  }

  void makeDirectionVectorUnitVector() {
    float magnitude = (float)Math.hypot(xdirection, ydirection);
    xdirection /= magnitude;
    ydirection /= magnitude;
  }


  // This method is called from main, and passed in the ball object
  Ball collide(Ball ball) { // default collide behaviour is to reflect x and y direction
    if (dist(ball.currentXPos, ball.currentYPos, this.currentXPos, this.currentYPos) < ball.rad + this.rad) {

      // move ball away from creature to avoid further collision
      if (this.xdirection <= 0) {
        ball.currentXPos += ball.rad;
      } else {
        ball.currentXPos -= ball.rad;
      }

      if (this.ydirection <= 0) {
        ball.currentYPos += ball.rad;
      } else {
        ball.currentYPos -= ball.rad;
      }
        
      ball.multiplyXDirection(-1);
      ball.multiplyYDirection(-1);

    }

    return ball;
  }

  


}