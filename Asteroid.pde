

class Asteroid {
  float x, y, xSpeed, ySpeed;
  
  Asteroid(float x, float y, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
  
  void move() {
    x += xSpeed;
    y += ySpeed;
    
    if (x < 0) x = width;
    if (x > width) x = 0;
    if (y < 0) y = height;
    if (y > height) y = 0;
  }

  void display() {
    fill(200);
    ellipse(x, y, 30, 30);
  }
  
  boolean hits(Bullet b) {
    float d = dist(x, y, b.x, b.y);
    return d < 15;
  }
}
