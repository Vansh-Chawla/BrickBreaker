Ball ball;
ArrayList<Brick> bricks;
Score score;
Lives lives;
Batty batty;

int paddleX, paddleY;
int paddleWidth = 75;
int paddleHeight = 10;
int borderThickness = 20;
int paddleSpeed = 8; 

boolean waitingForName = false;
String playerName = "";
Leaderboard leaderboard;
boolean showingLeaderboard = false; 

boolean leftKeyPressed = false;
boolean rightKeyPressed = false;

int offsetX, offsetY; // Brick grid starting position
int tileWidth = 80, tileHeight = 20; // Brick dimensions
int brickSpacing = 3; // Gap between bricks
int cols = 6, rows = 4; // Number of columns and rows of bricks

PFont customFont;
PFont emojiFont; 

int currentLevel = 1; // Start at Level 1

boolean gameCompleted = false;
String filePath = "newScores.txt";



void setup() {
  size(600, 420);
  frameRate(60);

  customFont = createFont("Arial.ttf", 24);
  textFont(customFont); // Set the custom font

  // Load the emoji font for symbols
  emojiFont = createFont("NotoEmoji-Regular.ttf", 24);

  leaderboard = new Leaderboard();
  leaderboard.loadScores(filePath);

  paddleX = (width - paddleWidth) / 2;
  paddleY = height - paddleHeight - 50;
  ball = new Ball(paddleX + paddleWidth / 2, paddleY - 20, 6);
  lives = new Lives(3);

  // Initialize the bricks array and score for the tests
  initialiseBricks();
  score = new Score();

  Tests test = new Tests();
  test.testingPowerUps();
  test.testingBrickHit();
  test.testBallCollision();
  test.testUpdatePosition();
  test.testLoseLife();
  test.testAddPoints();
  test.testSortScores();
  test.testTop5();
  test.testingMovingBrick();
  
  //for level 1
  initialiseBricks();
  score = new Score();
}


void draw() {
  background(30);

  if (showingLeaderboard) {
    leaderboard.display();
    return;
  }

  if (lives.haveRunOut()) {
    gameOver();
    return;
  }

  if (allBricksDestroyed()) {
    if (currentLevel == 1) {
      startLevel2(); 
      return;
    }
    if (currentLevel == 2) {
      startLevel3();
      return;
    }
    if (currentLevel == 3) {
        gameComplete();
        return;
      }
    
  }

  drawBorder();
  drawPaddle();

  if (leftKeyPressed) {
    paddleX = max(0 + borderThickness, paddleX - paddleSpeed); // don't let paddle go into the border
  } else if (rightKeyPressed) {
    paddleX = min(width - paddleWidth - borderThickness, paddleX + paddleSpeed); // don't let paddle go into the border
  }

  ball.updatePosition(width, height, borderThickness); // this also does all collision checks

  if (currentLevel == 3) { // only level 3 has creatures
    batty.updatePosition();
    batty.collide(ball);
    batty.checkCollisionWithWall(width, height, borderThickness);
    batty.draw();
  }

  ball.draw();

  for (Brick b : bricks) {
    b.draw();
  }

  // Draw the grid lines between bricks ONLY for Level 1
  // if (currentLevel == 1) {
  //   drawGrid(offsetX, offsetY, tileWidth, tileHeight, brickSpacing, cols, rows);
  // }

  
  drawTopBox(); // Display score and lives
}



boolean allBricksDestroyed() {
  for (Brick b : bricks) {
    if (!b.destroyed) {
      return false; // If bricks still exist, return false
    }
  }
  return true; // If all bricks are destroyed, return true
}



void initialiseBricks() {
  bricks = new ArrayList<Brick>();
  offsetX = (width - (cols * tileWidth + (cols - 1) * brickSpacing)) / 2;  // Center the bricks horizontally
  offsetY = borderThickness + 50;  // Leave space between the border and the first row of bricks

  int gridCellWidth = tileWidth + brickSpacing;   // Total width of each grid cell
  int gridCellHeight = tileHeight + brickSpacing; // Total height of each grid cell

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      BrickType type = (i == 0) ? BrickType.RED : (i == 1) ? BrickType.GREEN : BrickType.YELLOW;

      // centre the brick in its grid cell
      float x = offsetX + j * gridCellWidth + (gridCellWidth - tileWidth) / 2;
      float y = offsetY + i * gridCellHeight + (gridCellHeight - tileHeight) / 2;

      bricks.add(new Brick(x, y, tileWidth, tileHeight, type));
    }
  }
}



void drawTopBox() {
  // Drawing a semi-transparent black box at the top for score and lives
  fill(0, 150); // Semi-transparent black
  noStroke();
  rect(0, 0, width, 50); // Top box height = 50

  // Draw the score and lives
  fill(255);
  textSize(20);
  textAlign(LEFT, CENTER);
  
  // Set the emoji font for symbols
  textFont(emojiFont);
  fill(255, 204, 0);
  text("💯", 5, 25); // Star icon for score

  fill(255, 0, 0); // Red color for heart (lives icon)
  textAlign(RIGHT, CENTER);
  text("❤", width - 5, 25); // Heart icon for lives

  // Reset the font to customFont for normal text
  textFont(customFont);

  fill(255);
  textAlign(LEFT, CENTER);
  text("  Score: " + score.score, 30, 25);

  textAlign(RIGHT, CENTER);
  text("Lives: " + lives.lives + "  ", width - 30, 25);
}



void startLevel2() {
  currentLevel++;

  bricks.clear(); // Clear existing bricks

  paddleWidth = 75;  // Reset paddle to its initial length

  // Set a new brick arrangement for the level
  int cols = 6; // Number of columns of bricks
  int rows = 2; // Number of rows of bricks
  int tileWidth = 80; // Width of each brick
  int tileHeight = 20; // Height of each brick
  int brickSpacing = 5; // Gap between bricks
  int offsetX = (width - (cols * tileWidth + (cols - 1) * brickSpacing)) / 2;  // Center the bricks horizontally
  int offsetY = borderThickness + 50;  // Leave space between the border and the first row of bricks

  // Add 3 rows of moving bricks at the TOP of the screen
  int movingBrickRows = 3; // Number of moving brick rows
  int movingBrickCols = 2; // Number of bricks per row
  int movingBrickSpacing = tileWidth * 2; // Space between bricks
  int movingBrickYStart = offsetY; // Y position for the first moving brick row (top of the screen)


  // Different speeds for each row of moving bricks
  int[] movingBrickSpeeds = {3, 4, 5}; // Speed for each row

  for (int i = 0; i < movingBrickRows; i++) {
    for (int j = 0; j < movingBrickCols; j++) {
      // Calculate the initial X position for the moving bricks
      float x;
      float y = movingBrickYStart + i * (tileHeight + brickSpacing);

      // Define boundaries for each brick
      float leftBoundary, rightBoundary;

      if (j == 0) {
        // First column: left half of the screen
        x = offsetX; // Start at the left side
        leftBoundary = borderThickness;
        rightBoundary = width / 2;
      } else {
        // Second column: right half of the screen
        x = width / 2 + offsetX; // Start at the halfway point
        leftBoundary = width / 2;
        rightBoundary = width - borderThickness;
      }

      // Assign different speeds and directions
      int speed = movingBrickSpeeds[i]; // Unique speed for each row
      int direction = (i % 2 == 0) ? 1 : -1; // Alternate directions for each row

      // Create a moving brick with the appropriate type, speed, direction, and boundaries
      MovingBrick movingBrick = new MovingBrick(x, y, tileWidth, tileHeight, BrickType.values()[i], speed, leftBoundary, rightBoundary);
      movingBrick.direction = direction; // Set the initial direction
      bricks.add(movingBrick);
    }
  }

  // Add static bricks BELOW the moving bricks
  int staticBrickYStart = movingBrickYStart + movingBrickRows * (tileHeight + brickSpacing) + 20; // Y position for the first static brick row

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Skip certain positions to create empty spaces
      if ((i + j) % 2 == 0) {  // Example condition: skip every alternate brick
        BrickType type = BrickType.YELLOW; // Set all static bricks to yellow
        float x = offsetX + j * (tileWidth + brickSpacing);  // Add spacing between bricks
        float y = staticBrickYStart + i * (tileHeight + brickSpacing);  // Add spacing between rows
        bricks.add(new Brick(x, y, tileWidth, tileHeight, type));
      }
    }
  }

  // Reset the ball position and make it not moving
  ball.resetBall();
}



void startLevel3() {
  currentLevel++;

  bricks.clear();

  paddleWidth = 75; // reset paddle width
  paddleX = (600 - paddleWidth) / 2;

  ball = new Ball(paddleX + paddleWidth / 2, paddleY - 20, 7); // reset ball with faster speed

  batty = new Batty(4.5, 14, -1, 1, width, borderThickness);


  // add bricks as in level 1, but with heart and tnt powerup bricks
  bricks = new ArrayList<Brick>();
  offsetX = (width - (cols * tileWidth + (cols - 1) * brickSpacing)) / 2;  // Center the bricks horizontally
  offsetY = borderThickness + 50;  // Leave space between the border and the first row of bricks

  int gridCellWidth = tileWidth + brickSpacing;   // Total width of each grid cell
  int gridCellHeight = tileHeight + brickSpacing; // Total height of each grid cell

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      BrickType type = (i == 0) ? BrickType.RED : (i == 1) ? BrickType.GREEN : BrickType.YELLOW;
      
      if (type != BrickType.YELLOW) {
        PowerUpBrick powerUpBrick = new PowerUpBrick(offsetX + j * gridCellWidth, offsetY + i * gridCellHeight, tileWidth, tileHeight, type, lives);

        //int randomrow = (int) random(rows - 2);
        //int randomcol = (int) random(cols);
        if (i == 1 && j == 0) {
          powerUpBrick.setPowerType("life");
          bricks.add(powerUpBrick);
        } 
        else if (i == 1 && j == 5) {
          powerUpBrick.setPowerType("life");
          bricks.add(powerUpBrick);
        }
        else if (i == 0 && j == 4) {
          powerUpBrick.setPowerType("tnt");
          bricks.add(powerUpBrick);
        }
        else if (i == 1 && j == 2) {
          powerUpBrick.setPowerType("tnt");
          bricks.add(powerUpBrick);
        }
        else {
          bricks.add(new Brick(offsetX + j * gridCellWidth, offsetY + i * gridCellHeight, tileWidth, tileHeight, type));
        }
        } else {
          bricks.add(new Brick(offsetX + j * gridCellWidth, offsetY + i * gridCellHeight, tileWidth, tileHeight, type));
        }
      }
  }

}



void gameComplete() {
  gameCompleted = true;
  background(0);
  textSize(20);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text(" Congratulations! GAME COMPELETED", width / 2, height / 2 - 50);
  leaderboard.loadScores(filePath);
  textSize(20);
  fill(255);
  text("Enter your name:", width / 2, height / 2);
  text(playerName, width / 2, height / 2 + 30);
    
  // Draw "View Leaderboard" button
  fill(255);
  rect(width / 2 - 70, height / 2 + 60, 140, 30);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  rect(width / 2 - 70, height / 2 + 60, 140, 30);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Enter to view Leaderboard", width / 2, height / 2 + 75);
  waitingForName = true; // Wait for player to enter their name before saving the score
}



// draws grid between bricks, although no longer using this
void drawGrid(int offsetX, int offsetY, int tileWidth, int tileHeight, int brickSpacing, int cols, int rows) {
  stroke(150, 150, 255); // Light blue for grid lines (more visible)
  strokeWeight(1); // Thin lines for subtle grid
  noFill();

  // Draw vertical grid lines with space between bricks
  for (int col = 0; col <= cols; col++) {
    float x = offsetX + col * (tileWidth + brickSpacing); // X position for each column line
    line(x, offsetY, x, offsetY + rows * (tileHeight + brickSpacing));  // Draw vertical line
  }

  // Draw horizontal grid lines with space between bricks
  for (int row = 0; row <= rows; row++) {
    float y = offsetY + row * (tileHeight + brickSpacing); // Y position for each row line
    line(offsetX, y, offsetX + cols * (tileWidth + brickSpacing), y);  // Draw horizontal line
  }
}



void keyPressed() {
  // this method is automatically called when a key such as left, right, shift is pressed. It moves the padde
  if (keyCode == LEFT) {
    leftKeyPressed = true;
  } else if (keyCode == RIGHT) {
    rightKeyPressed = true;

  }
  if (key == ' ') { ball.ballMoving = true; }
}



void keyReleased() {
  // i.e. stop moving the paddle
  leftKeyPressed = false; 
  rightKeyPressed = false;
}



void keyTyped() {
  // this method is automatically executed every time a key is pressed
  if (waitingForName && !showingLeaderboard) {
    if (key == ENTER || key == RETURN) {
      leaderboard.saveScore(playerName, score.score);  // Save to leaderboard - only score for now
      //waitingForName = false;  // Stop waiting for name
      showingLeaderboard = true;
      leaderboard.loadScores(filePath);

      // Display leaderboard immediately after saving the score
      leaderboard.display();
    } else if (key == BACKSPACE && playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    } else if (key != CODED) { // coded keys are game keys like up, down, left, right, ctrl, shift
      playerName += key;
    }
  }
}



void drawPaddle() {
  fill(255);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
}



void drawBorder() {
  fill(150);
  rect(0, 0, width, borderThickness); // top border 
  rect(0, 0, borderThickness, height); // left border
  rect(width - borderThickness, 0, borderThickness, height); // right border
}



void gameOver() {
  // this  method just displays the game over screen, and doesn't handle any subsequent leaderboarding or entering of usernames
  background(0);
  textSize(40);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 50);

  if (leaderboard.top5(score.score)) {
    leaderboard.loadScores(filePath);
    textSize(20);
    fill(255);
    text("Enter your name:", width / 2, height / 2);
    text(playerName, width / 2, height / 2 + 30);
    //waitingForName = true;
    // Draw "View Leaderboard" button
    fill(255);
    rect(width / 2 - 70, height / 2 + 60, 140, 30);
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    //text("Enter to view Leaderboard", width / 2, height / 2 + 75);
  }

  // Draw "View Leaderboard" button
  fill(0);
  rect(width / 2 - 70, height / 2 + 60, 140, 30);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Enter to view Leaderboard", width / 2, height / 2 + 75);
  waitingForName = true; // Wait for player to enter their name before saving the score
}


void mousePressed() {
  // this method is automatically executed every time the mouse button is pressed
  if (showingLeaderboard) {
    // Check if the "Restart" button is clicked on the leaderboard page
    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50 &&
        mouseY > height - 80 && mouseY < height - 50) {
      resetGame();  // Reset the game
      showingLeaderboard = false;  // Hide the leaderboard and return to the game
    } else if (mouseX > width / 2 - 70 && mouseX < width / 2 + 70 &&
      mouseY > height / 2 + 60 && mouseY < height / 2 + 90) {
      
      showingLeaderboard = true;  // Show the leaderboard
      leaderboard.loadScores(filePath);  // Ensure scores are loaded before displaying
    }
  }
}



void resetGame() {
  // Reset lives, score, ball position, and bricks
  lives = new Lives(3);
  score = new Score();

  // Reset the ball
  paddleX = (600 - paddleWidth) / 2;
  ball = new Ball(paddleX + paddleWidth / 2, paddleY - 10, 6);

  // Reset the bricks (same as when game starts)
  bricks.clear();
  initialiseBricks();


  // Reset the player's name and waiting for input flag
  playerName = "";
  waitingForName = false;  // No longer waiting for name when restarting
  showingLeaderboard = false;  // Ensure leaderboard is not shown after restart

  // Reset the level counter
  currentLevel = 1;
}
