Ball ball;
ArrayList<Brick> bricks;
Score score;
Lives lives;

int rectX, rectY, rectWidth = 100, rectHeight = 10;
int borderThickness = 20;

boolean waitingForName = false;
String playerName = "";
Leaderboard leaderboard;

boolean showingLeaderboard = false;  // New flag to track leaderboard visibility

int offsetX, offsetY; // Brick grid starting position
int tileWidth = 80, tileHeight = 20; // Brick dimensions
int brickSpacing = 5; // Gap between bricks
int cols = 6, rows = 4; // Number of columns and rows

PFont customFont;
PFont emojiFont; 

int currentLevel = 1; // Start at Level 1

void setup() {
  size(600, 420);
  frameRate(60);

  customFont = createFont("Arial.ttf", 24);
  textFont(customFont); // Set the custom font

  // Load the emoji font for symbols
  emojiFont = createFont("NotoEmoji-Regular.ttf", 24);

  leaderboard = new Leaderboard();
  leaderboard.loadScores();

  rectX = (width - rectWidth) / 2;
  rectY = height - rectHeight - 50;
  ball = new Ball(rectX + rectWidth / 2, rectY - 10);
  score = new Score();
  lives = new Lives(3);

  // Initialize bricks
  bricks = new ArrayList<Brick>();
  offsetX = (width - (cols * tileWidth + (cols - 1) * brickSpacing)) / 2;  // Center the bricks horizontally
  offsetY = borderThickness + 50;  // Leave space between the border and the first row of bricks

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int type = (i == 0) ? 1 : (i == 1) ? 3 : 2;
      float x = offsetX + j * (tileWidth + brickSpacing);
      float y = offsetY + i * (tileHeight + brickSpacing);
      bricks.add(new Brick(x, y, tileWidth, tileHeight, type));
    }
  }
}

boolean allBricksDestroyed() {
  for (Brick b : bricks) {
    if (!b.destroyed) {
      return false; // If any brick is not destroyed, return false
    }
  }
  return true; // If all bricks are destroyed, return true
}

void draw() {
  background(30);

  if (showingLeaderboard) {
    leaderboard.display();
    return;
  }

  if (lives.isGameOver()) {
    gameOver();
    return;
  }

  if (allBricksDestroyed()) {
    nextLevel(); // Proceed to the next level when all bricks are cleared
    return;
  }

  drawBorder();
  drawMovableRectangle();

  ball.update();
  ball.checkCollision(width, height, borderThickness);
  ball.draw();

  for (Brick b : bricks) {
    b.draw();
  }

  // Draw the grid lines between bricks ONLY for Level 1
  if (currentLevel == 1) {
    drawGrid(offsetX, offsetY, tileWidth, tileHeight, brickSpacing, cols, rows);
  }

  // Display score and lives
  drawTopBox();
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

void nextLevel() {
  currentLevel++; // Increment the level counter

  // Clear existing bricks
  bricks.clear();

  // Reset paddle length
  rectWidth = 100;  // Reset paddle to its initial length

  // Set a new brick arrangement for the next level
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

  // Colors for the moving bricks (based on type)
  int[] movingBrickTypes = {2, 1, 3}; // Yellow, Red, Green

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
        leftBoundary = 0;
        rightBoundary = width / 2;
      } else {
        // Second column: right half of the screen
        x = width / 2 + offsetX; // Start at the halfway point
        leftBoundary = width / 2;
        rightBoundary = width;
      }

      // Assign different speeds and directions
      int speed = movingBrickSpeeds[i]; // Unique speed for each row
      int direction = (i % 2 == 0) ? 1 : -1; // Alternate directions for each row

      // Create a moving brick with the appropriate type, speed, direction, and boundaries
      MovingBrick movingBrick = new MovingBrick(x, y, tileWidth, tileHeight, movingBrickTypes[i], speed, leftBoundary, rightBoundary);
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
        int type = 2; // Set all bricks to yellow (type 2)
        float x = offsetX + j * (tileWidth + brickSpacing);  // Add spacing between bricks
        float y = staticBrickYStart + i * (tileHeight + brickSpacing);  // Add spacing between rows
        bricks.add(new Brick(x, y, tileWidth, tileHeight, type));
      }
    }
  }

  // Reset the ball position and make it not moving
  ball.resetBall();
}

// Function to draw the grid with space between bricks
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
  if (keyCode == LEFT) {
    rectX = max(0, rectX - 60);
  } else if (keyCode == RIGHT) {
    rectX = min(width - rectWidth, rectX + 60);
  }
  if (key == ' ') ball.ballMoving = true;
}

void keyTyped() {
  if (waitingForName) {
    if (key == ENTER || key == RETURN) {
      leaderboard.saveScore(playerName, score.score);  // Save to leaderboard
      waitingForName = false;  // Stop waiting for name

      // Display leaderboard immediately after saving the score
      leaderboard.display();
    } else if (key == BACKSPACE && playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    } else if (key != CODED) {
      playerName += key;
    }
  }
}

void drawMovableRectangle() {
  fill(255);
  rect(rectX, rectY, rectWidth, rectHeight);
}

void drawBorder() {
  fill(150);
  rect(0, 0, width, borderThickness);
  rect(0, 0, borderThickness, height);
  rect(0, height - borderThickness, width, borderThickness);
  rect(width - borderThickness, 0, borderThickness, height);
}

void gameOver() {
  background(0);
  textSize(40);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 50);

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
  text("View Leaderboard", width / 2, height / 2 + 75);

  waitingForName = true;  // Wait for player to enter their name before saving the score
}

void mousePressed() {
  if (showingLeaderboard) {
    // Check if the "Restart" button is clicked on the leaderboard page
    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50 &&
        mouseY > height - 80 && mouseY < height - 50) {
      resetGame();  // Reset the game
      showingLeaderboard = false;  // Hide the leaderboard and return to the game
    }
  } else {
    // Check if the "View Leaderboard" button is clicked on the Game Over screen
    if (mouseX > width / 2 - 70 && mouseX < width / 2 + 70 &&
        mouseY > height / 2 + 60 && mouseY < height / 2 + 90) {
      showingLeaderboard = true;  // Show the leaderboard
      leaderboard.loadScores();  // Ensure scores are loaded before displaying
    }
  }
}

void resetGame() {
  // Reset lives, score, ball position, and bricks
  lives = new Lives(3);
  score = new Score();

  // Reset the ball
  ball = new Ball(rectX + rectWidth / 2, rectY - 10);

  // Reset the bricks (same as when game starts)
  bricks.clear();
  int cols = 6, rows = 4, tileWidth = 80, tileHeight = 20;
  int offsetX = (width - (cols * tileWidth)) / 2, offsetY = 50;

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int type = (i == 0) ? 1 : (i == 1) ? 3 : 2;
      bricks.add(new Brick(offsetX + j * tileWidth, offsetY + i * tileHeight, tileWidth, tileHeight, type));
    }
  }

  // Reset the player's name and waiting for input flag
  playerName = "";
  waitingForName = false;  // No longer waiting for name when restarting
  showingLeaderboard = false;  // Ensure leaderboard is not shown after restart

  // Reset the level counter
  currentLevel = 1;
}