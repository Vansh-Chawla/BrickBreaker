class PowerUpBrick extends Brick {
  String specialLife = "❤";
  String specialTNT = "💣";
  String specialChar;
  Lives lives;
  PFont emojiFont;

  PowerUpBrick(float xPos, float yPos, float w, float h, BrickType type, Lives lives) {
    super(xPos, yPos, w, h, type);
    this.col = type.getColor(0);
    this.emojiFont = emojiFont;
    this.lives = lives;
  }
    
  void setPowerType (String powerType) {
    if (powerType.equalsIgnoreCase("life")) {
      specialChar = specialLife;
    }
    else if (powerType.equalsIgnoreCase("tnt")) {
      specialChar = specialTNT;
    }
  }

  @Override
  void draw() {
    if(!destroyed) {
      col = type.getColor(hitCount);
      fill(col);
      rect(xPos, yPos, width, height);
      emojiFont = createFont("NotoEmoji-Regular.ttf", 24);
      textFont(emojiFont);
      textSize(12);
      textAlign(CENTER, CENTER);
      fill(255, 255, 255);
      text(specialChar, xPos + width / 2, yPos + height /2);
    }
  }

  @Override
  void hit() {
    hitCount++; 

    if (type == BrickType.GREEN && hitCount == 2) {  // Green brick (2 hits required)
      if (specialChar.equals(specialLife)) {
        lives.lives++;
      } else if (specialChar.equals(specialTNT)) {
        tnt();
      }
      destroyed = true;

    } else if (type == BrickType.RED && hitCount == 3) {  // Red brick (3 hits required)
        if (specialChar.equals(specialLife)) {
          lives.lives++;
        } else if (specialChar.equals(specialTNT)) {
          tnt();
        }
        destroyed = true;
    }    
  }

  void tnt() { // hit surrounding bricks
    for (Brick b : bricks) {
      if (b != this && dist(b.xPos, b.yPos, xPos, yPos) < 100) { // 100 is the radius of destruction
        b.hit();
      }
    }
  }

}
