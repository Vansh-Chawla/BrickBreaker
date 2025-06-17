class Score {
    int score; // Stores the player's score

    Score() {
        score = 0; // Initializes score to 0
    }

    void addPoints(int points) {
        score += points; // Adds points to the score
    }

    void display() {
        textSize(20);        // Sets text size
        fill(255);           // Sets text color to white
        text("Score: " + score, width / 2 - 50, 30); // Displays the score
    }
}
