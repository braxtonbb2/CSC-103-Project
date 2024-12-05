
int playerX, playerY;
float playerAngle = 0;
int playerSpeed = 4;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

int score = 0;                // Point system
int timeLimit = 45;           // Time limit in seconds
int startTime;

boolean gameEnded = false;    // Track if the game has ended

enum GameState { COVER, PLAY }
GameState gameState = GameState.COVER;

void setup() {
  size(800, 600);
  resetGame();                // Initialize the game
}

void draw() {
  if (gameState == GameState.COVER) {
    drawCoverScreen();
    return;
  }

  if (gameEnded) return;      // Stop the game loop when the game ends

  background(0);              // Clear screen with black background

  // Draw and move the player
  pushMatrix();
  translate(playerX, playerY);
  rotate(playerAngle);
  fill(255);
  triangle(-15, 10, 15, 10, 0, -15);  // Spaceship shape
  popMatrix();

  // Handle player movement
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      playerX += cos(radians(playerAngle)) * playerSpeed;
      playerY += sin(radians(playerAngle)) * playerSpeed;
    }
    if (key == 'a' || key == 'A') {
      playerAngle -= 5;
    }
    if (key == 'd' || key == 'D') {
      playerAngle += 5;
    }
  }

  // Handle bullet movement and drawing
  for (int i = bullets.size() - 1; i >= 0; i--) {
    bullets.get(i).move();
    bullets.get(i).display();
    if (bullets.get(i).isOffScreen()) {
      bullets.remove(i);
    }
  }

  // Handle asteroid movement and drawing
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    a.move();
    a.display();

    // Check for collisions with the player
    float distance = dist(playerX, playerY, a.x, a.y);
    if (distance < 20) {
      endGame("Game Over! Final Score: " + score);
      return;
    }
  }

  // Check for collisions between bullets and asteroids
  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid a = asteroids.get(i);
    for (int j = bullets.size() - 1; j >= 0; j--) {
      Bullet b = bullets.get(j);
      if (a.hits(b)) {
        asteroids.remove(i);
        bullets.remove(j);
        score += 10;          // Add points when an asteroid is destroyed
        break;
      }
    }
  }

  // Spawn a new asteroid every 100 frames
  if (frameCount % 100 == 0) {
    asteroids.add(new Asteroid(random(width), random(height), random(-2, 2), random(-2, 2)));
  }

  // Display the score
  fill(255);
  textSize(20);
  text("Score: " + score, 10, 20);

  // Display the time left
  int elapsedTime = (millis() - startTime) / 1000;
  int timeLeft = timeLimit - elapsedTime;
  text("Time Left: " + timeLeft, 10, 40);

  // End the game if time runs out
  if (timeLeft <= 0) {
    endGame("Time's Up! Final Score: " + score);
  }
}

void drawCoverScreen() {
  background(0);
  textSize(48);
  fill(255);
  textAlign(CENTER, CENTER);
  text("BLASTER", width / 2, height / 2 - 50);

  textSize(24);
  text("Press 'ENTER' or 'P' to Start", width / 2, height / 2 + 20);
  text("Press 'R' anytime to Restart", width / 2, height / 2 + 60);
}

void keyPressed() {
  if (gameState == GameState.COVER) {
    if (key == ENTER || key == 'p' || key == 'P') {
      gameState = GameState.PLAY;
      resetGame();
    }
  } else if (key == ' ') {
    if (!gameEnded) {
      float bulletSpeed = 10;
      float angleRad = radians(playerAngle);
      Bullet b = new Bullet(playerX + cos(angleRad) * 20, playerY + sin(angleRad) * 20, cos(angleRad) * bulletSpeed, sin(angleRad) * bulletSpeed);
      bullets.add(b);
    }
  } else if (key == 'r' || key == 'R') {
    gameState = GameState.PLAY;
    resetGame();
  }
}

void endGame(String message) {
  noLoop();
  gameEnded = true;
  fill(255, 0, 0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(message, width / 2, height / 2);
  text("Press 'R' to Restart", width / 2, height / 2 + 40);
}

void resetGame() {
  playerX = width / 2;
  playerY = height / 2;
  playerAngle = 0;
  bullets.clear();
  asteroids.clear();
  score = 0;
  startTime = millis();
  gameEnded = false;
  loop();
}
