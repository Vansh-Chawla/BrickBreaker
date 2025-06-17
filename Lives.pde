class Lives {
  int lives; // Number of remaining lives

  // Constructor to initialize the number of lives
  Lives(int initialLives) {
    lives = initialLives;
  }

  // Decrease the number of lives when the player loses a life
  void loseLife() {
    if (lives > 0) {
      lives--; // Reduce life count by 1
    }
  }

  // Check if the game is over (no lives remaining)
  boolean haveRunOut() {
    return lives <= 0;
  }

  // Display the number of lives on the screen
  void display() {
    textSize(20); // Set text size
    fill(255); // Set text color to white
    text("Lives: " + lives, width / 2 + 50, 30);  // Show lives count next to score
  }
}
