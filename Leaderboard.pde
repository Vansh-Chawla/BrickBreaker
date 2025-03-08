class Leaderboard {
  // List to store player scores
  ArrayList<ScoreEntry> scores;

  // Constructor initializes the scores list
  Leaderboard() {
    scores = new ArrayList<ScoreEntry>();
  }

  // Load scores from a file and update the leaderboard
  void loadScores() {
    scores.clear();  // Clear existing scores before loading new ones
    String[] lines = loadStrings("scores.txt");  // Load scores from a file
    if (lines != null) {
      for (String line : lines) {
        String[] parts = line.split(",");  // Split name and score by comma
        if (parts.length == 2) {
          String name = parts[0].trim();
          int score = int(parts[1].trim());
          scores.add(new ScoreEntry(name, score)); // Add entry to the list
        }
      }
    }
    sortScores();  // Sort scores in descending order
  }

  // Sort scores in descending order using a simple bubble sort
  void sortScores() {
    for (int i = 0; i < scores.size() - 1; i++) {
      for (int j = i + 1; j < scores.size(); j++) {
        if (scores.get(i).score < scores.get(j).score) {
          // Swap elements if the next score is higher
          ScoreEntry temp = scores.get(i);
          scores.set(i, scores.get(j));
          scores.set(j, temp);
        }
      }
    }
  }

  // Display the leaderboard on the screen
  void display() {
    background(30); // Set background color
    textSize(40);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Leaderboard", width / 2, 50);

    // Display top 5 scores
    textSize(24);
    fill(255);
    textAlign(CENTER, CENTER);
    int y = 120;
    for (int i = 0; i < min(5, scores.size()); i++) {
      ScoreEntry entry = scores.get(i);
      text((i + 1) + ". " + entry.name + " - " + entry.score, width / 2, y);
      y += 30;
    }

    // Draw "Restart" button
    fill(255);
    rect(width / 2 - 50, height - 80, 100, 30);  // Button placement
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text("Restart", width / 2, height - 65);
  }

  // Save a new score entry and update the leaderboard
  void saveScore(String name, int score) {
    scores.add(new ScoreEntry(name, score)); // Add new entry
    sortScores();  // Sort scores after addition
    saveScores();  // Save updated scores to file
  }

  // Save the leaderboard scores to a file
  void saveScores() {
    String[] lines = new String[scores.size()];
    for (int i = 0; i < scores.size(); i++) {
      ScoreEntry entry = scores.get(i);
      lines[i] = entry.name + "," + entry.score; // Format as "name,score"
    }
    saveStrings("scores.txt", lines);  // Write scores to file
  }
}

// Class representing a single score entry
class ScoreEntry {
  String name; // Player name
  int score;  // Player score

  // Constructor to initialize name and score
  ScoreEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }
}