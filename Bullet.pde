
class Bullet {
  float x, y, xSpeed, ySpeed;
  
  Bullet(float x, float y, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
  
  void move() {
    x += xSpeed;
    y += ySpeed;
  }
  
  void display() {
    fill(255, 0, 0);
    ellipse(x, y, 5, 5);
  }

  boolean isOffScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}
