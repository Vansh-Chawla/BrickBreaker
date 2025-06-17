class Tests {

    
    //Testing PowerUpBrick class
    void testingPowerUps() {
        Lives livesTest = new Lives(3);
        PowerUpBrick test = new PowerUpBrick(100, 100, 50, 25, BrickType.GREEN, livesTest);
        test.setPowerType("life");
        test.hitCount = 1;
        test.hit();
        if (livesTest.lives == 4) {       
            println("Testing the setPowerType method from the PowerUpBrick class: Passed");
        } else {
            println("Testing the setPowerType method from the PowerUpBrick class: Failed");
        }
    }

    //testing MovingBrick class
    void testingMovingBrick() {
        MovingBrick moving = new MovingBrick(100, 100, 50, 25, BrickType.YELLOW, 5, 120, 80);
        moving.update();

        if (moving.xPos == 100) {
            println("Testing the update method from the MovingBrick class: Failed");
        } else {
            println("Testing the update method from the MovingBrick class: Passed");
        }

    }

    //testing Brick class
    void testingBrickHit() { 
        Brick test = new Brick(100, 100, 50, 25, BrickType.YELLOW);

        test.hit();

        if (test.destroyed == true) {
            println("Testing the hit method from the Brick class: Passed");
        } else {
            println("Testing the hit method from the Brick class: Failed");
        }
    }
    
    //testing Ball class
    void testBallCollision() {
        Brick b = new Brick(100, 100, 50, 25, BrickType.GREEN);

        Ball test = new Ball(110, 110, 6);

        test.updatePosition(120, 120, 5);
        if (test.checkBrickCollision() == true) {
            println("Testing BrickCollision method from the Ball class: Passed");
        } else {
            println("Testing BrickCollision method from the Ball class: Failed");
        }
    }

    void testUpdatePosition() {
        Ball test = new Ball(110, 110, 6);

        test.ballMoving = true;

        float x = test.currentXPos;

        test.updatePosition(800, 800, 20);

        if (test.currentXPos == x) {
            println("Testing the UpdatePosition method from the Ball class: Failed");
        } else {
            println("Testing the UpdatePosition method from the Ball class: Passed");
        }
    }

    //testing Score class
    void testAddPoints() {
        Score testScore = new Score();
        testScore.addPoints(4);

        if (testScore.score == 4) {
            println("Testing the addPoints method from the Score class: Passed");
        } else{
            println("Testing the addPoints method from the Score class: Failed");
        }
    }

    //testing Lives class
    void testLoseLife() {
        Lives livesTest = new Lives(3);
        livesTest.loseLife();
        if (livesTest.lives == 2) {
            println("Testing the LoseLife method from the Lives class: Passed");
        } else {
            println("Testing the LoseLife method from the Lives class: Failed");
        }
    }

    //testing Leaderboard class
    void testSortScores() {
        Leaderboard leaderboard = new Leaderboard();
        String filePath = "testScores.txt";
        leaderboard.loadScores(filePath);
      
        if (leaderboard.scores.get(0).name.equals("Jeff")) {
            println("Testing sortingScores from the Leaderboard class: Passed");
        } else {
            println("Testing sortingScores from the Leaderboard class: Failed");
        }
    }

    void testTop5() {
        Leaderboard leaderboard = new Leaderboard();
        String filePath = "testScores.txt";
        leaderboard.loadScores(filePath);
        boolean isIT = leaderboard.top5(21);

        if (isIT == true) {
            println("Testing the top5 method from the Leaderboard class: Passed");
        } else {
            println("Testing the top5 method from the Leadrboard class: Failed");
        }
    }
}
