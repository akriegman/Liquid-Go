import java.util.*;
import java.time.LocalDateTime;
import java.nio.file.Paths;

PlayerGo player1;
PlayerGo player2;
color board = color(180, 140, 30);
int growRate = 30;
float computerX;
float computerY;
float computerXnext;
float computerYnext;
float playerX;
float playerY;
float playerXnext;
float playerYnext;
float speed = 0.2;
boolean pause = false;

void setup ()
{
  background(board);
  size(720, 720);
  loadPixels();
  
  player1 = new PlayerGo(color(255, 255, 224));
  player2 = new PlayerGo(color(0, 0, 32));
  mouseX = width/4;
  mouseY = height/2;
  playerX = width/4;
  playerY = height/2;
  computerX = width/4*3;
  computerY = height/2;
}

void draw ()
{ 
  if (millis() < 2000 || pause) { return; }
  
  // Player coordinates should be 0 <= x < width, similar for y.
  // Since we round down to get the cell coordinates,
  // and the player coordinates are only approaching the mouse
  // coordinates, it's okay to clamp mouseX above by width
  // instead of width - 1.
  mouseX = Math.max(0, Math.min(width, mouseX));
  mouseY = Math.max(0, Math.min(height, mouseY));
  
  computerXnext = computerX + (mouseX - computerX) * speed/2;
  computerYnext = computerY + (mouseY - computerY) * speed/2;
  playerXnext = playerX + (mouseX - playerX) * speed;
  playerYnext = playerY + (mouseY - playerY) * speed;
  
  for (int i = 0; i < growRate; i++) {
    //computerX += (mouseX - computerX) * speed/2;
    //computerY += (mouseY - computerY) * speed/2;
    //playerX += (mouseX - playerX) * speed;
    //playerY += (mouseY - playerY) * speed;
    
    player1.spill(int(playerX * float(growRate - i) / growRate + playerXnext * float(i) / growRate), 
                  int(playerY * float(growRate - i) / growRate + playerYnext * float(i) / growRate), 1);
    
    //player1.spill(mouseX, mouseY, 1);
    //player2.spill((int) (width/2 + cos((float) millis()/1000)*height/4), (int) (height/2 + sin((float) millis()/1000)*height/4), 1);
    player2.spill(int(computerX * float(growRate - i) / growRate + computerXnext * float(i) / growRate), 
                  int(computerY * float(growRate - i) / growRate + computerYnext * float(i) / growRate), 1);
  }
  updatePixels();
  
  computerX = computerXnext;
  computerY = computerYnext;
  playerX = playerXnext;
  playerY = playerYnext;
  
  if (player2.boundary.size() == 0 && player1.boundary.size() == 0) {
    noLoop();
    int w = 0;
    int b = 0;
    int u = 0;
    for (color c : pixels) {
      if (c == player1.flag) {w++;};
      if (c == player2.flag) {b++;};
      if (c == board) {u++;};
    }
    println("White Territory: " + (w + u));
    println("Black Territory: " + b);
    screenshot();
  }
}

void keyPressed ()
{
  switch (key) {
    case 's': screenshot();   break;
    case 'p': pause = !pause; break;
    case 'j': growRate -= 10; break;
    case 'k': growRate += 10; break;
  }
}

void screenshot()
{
  save("screenshots/image_" + LocalDateTime.now().toString().replace(':', '-') + ".png");
}
