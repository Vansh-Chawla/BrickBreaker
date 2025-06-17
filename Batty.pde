class Batty extends Creature {
    float startXPos, startYPos;

    Batty(float speed, float rad, float startxdirection, float startydirection, float width, float borderThickness) {
        super(width - borderThickness - rad * 2, borderThickness + rad * 2, speed, rad, startxdirection, startydirection);
        startXPos = width - borderThickness - rad * 2;
        startYPos = borderThickness + rad * 2;
        // the current x pos and current y pos are the centre of the (equilateral) triangle - i.e. equidistant from each vertex
    }

    @Override
    Ball collide(Ball ball) { // this method changes the direction of the ball randomly upon collision
        if (dist(ball.currentXPos, ball.currentYPos, this.currentXPos, this.currentYPos) < (ball.rad + this.rad)) {

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
            

            // for determining the random direction of the ball after collision
            float negballXMultiplier = random(-0.85, -0.15);
            float posballXMultiplier = random(0.15, 0.85);

            float negballYMultiplier = random(-0.85, -0.15);
            float posballYMultiplier = random(0.15, 0.85);

            if (random(-1, 1) >= 0) {
                ball.multiplyXDirection(posballXMultiplier);
                if (random(-1, 1) >= 0) {
                    ball.multiplyYDirection(posballYMultiplier);
                } else {
                    ball.multiplyYDirection(negballYMultiplier);
                }
            } else {
                ball.multiplyXDirection(negballXMultiplier);
            }
        }
        return ball;
    }
    

    @Override
    void updatePosition() {
        currentXPos += (xdirection * speed);
        currentYPos += (ydirection * speed);
    }

    @Override
    void draw() {
        fill(9, 255, 0);

        // currentXPos, currentYPos is the centre of an equilateral triangle, equidistant from each vertex
        float topXVertex = currentXPos;
        float topYVertex = currentYPos - this.rad;

        float rightXVertex = currentXPos + sqrt( (this.rad*this.rad) - (this.rad*cos((float)Math.PI/3))*(this.rad*cos((float)Math.PI/3)) );
        float rightYVertex = currentYPos + (this.rad * cos((float)Math.PI/3));
        
        float leftXVertex = currentXPos - sqrt( (this.rad*this.rad) - (this.rad*cos((float)Math.PI/3))*(this.rad*cos((float)Math.PI/3)) );
        float leftYVertex = currentYPos + (this.rad * cos((float)Math.PI/3) );

         
        triangle(topXVertex, topYVertex, rightXVertex, rightYVertex, leftXVertex, leftYVertex);
    }

}